function ArrayEquals([Object[]]$a, [Object[]]$b) {
    $ac = $a.Count
    $bc = $b.Count
    if ($ac -ne $bc) {
        echo $ac, $bc
        return $false
    }

    for ($i = 0; $i -lt $ac; ++$i) {
        if ($a[$i] -ne $b[$i]) {
            return $false
        }
    }

    return $true
}

$ips = Get-Content .\ip-blacklist.txt | Sort-Object -Unique
Write-Output $ips

$rule = Get-NetFirewallRule -DisplayName 'BanIP-TCP'
$af = Get-NetFirewallAddressFilter -AssociatedNetFirewallRule $rule
$ips += $af.RemoteAddress
$ips = $ips | Sort-Object -Unique
$eq = ArrayEquals $ips $af.RemoteAddress
"Unchanged?: " + $eq
if (-not $eq) {
    Set-NetFirewallAddressFilter -InputObject $af -RemoteAddress $ras
}
