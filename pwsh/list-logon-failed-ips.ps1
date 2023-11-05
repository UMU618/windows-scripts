$ips = @{}
Get-WinEvent -LogName Security -FilterXPath '*[System[band(Keywords,4503599627370496)] and EventData[Data[@Name="LogonType"]=3]]' | %{
    $xml = [xml]$_.toXml()
    $user = ''
    $ip = ''
    foreach ($data in $xml.Event.EventData.Data) {
        if ($data.Name -eq 'TargetUserName') {
            $user = $data.'#text'
        }
        elseif ($data.Name -eq 'IpAddress') {
            $ip = $data.'#text'
        }
    }
    if (-not $ip.Equals('')) {
        if ($ips.ContainsKey($ip)) {
            ++$ips[$ip]
        } else {
            $ips.Add($ip, 1)
            'Fisrt find ' + $ip + ' with ' + $user + ' on ' + $_.TimeCreated
        }
    }
}
Write-Output 'All IPs for auditing:', $ips

Out-File .\new-ips.txt -Encoding utf8 -InputObject $ips.Keys