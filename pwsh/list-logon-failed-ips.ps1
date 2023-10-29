$ips = @{}
Get-WinEvent -LogName Security -FilterXPath '*[System[band(Keywords,4503599627370496)] and EventData[Data[@Name="LogonType"]=3]]' | %{
    $xml = [xml]$_.toXml()
    foreach ($data in $xml.Event.EventData.Data) {
        if ($data.Name -eq 'IpAddress') {
            $ip = $data.'#text'
            if ($ips.ContainsKey($ip)) {
                ++$ips[$ip]
            } else {
                $ips.Add($ip, 1)
                'Fisrt find ' + $ip + ' on ' + $_.TimeCreated
            }
        }
    }
}
Write-Output 'All IPs:', $ips