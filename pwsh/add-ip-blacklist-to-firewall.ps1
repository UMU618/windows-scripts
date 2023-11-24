function ArrayEquals([Object[]]$a, [Object[]]$b) {
    $ac = $a.Count
    $bc = $b.Count
    if ($ac -ne $bc) {
        return $false
    }

    for ($i = 0; $i -lt $ac; ++$i) {
        if ($a[$i] -ne $b[$i]) {
            return $false
        }
    }

    return $true
}

$ips = Get-Content .\new-ips.txt -Encoding UTF8 | Sort-Object -Unique
Write-Output "Add:"
Write-Output $ips

$rule = Get-NetFirewallRule -DisplayName 'BanIP-TCP'
$af = Get-NetFirewallAddressFilter -AssociatedNetFirewallRule $rule
$old = $af.RemoteAddress | Sort-Object
Write-Output "Old:"
Write-Output $old

$ips = ([System.Collections.ArrayList]::new() + $ips + $old) | Sort-Object -Unique
Write-Output "New:"
Write-Output $ips
$eq = ArrayEquals $ips $old
"Unchanged?: " + $eq
if (-not $eq) {
    Set-NetFirewallAddressFilter -InputObject $af -RemoteAddress $ips
    Out-File .\ip-blacklist.txt -Encoding utf8 -InputObject $ips
}
