#$ipv4addr ='\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b' #regex for a valid ipv4 address
#$dnsaddr = '\b(?:(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,})\b' #regex for a valid dns address
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$prefix = "local=/" 
$suffix = "/" 
$list = "list.txt"
$lineCount = (Get-Content $list | Measure-Object -Line).Lines
write-host "Total Lines in input file: $lineCount"
if (Test-Path -Path ".\dnsmasq_blocklist.txt") { Remove-Item -Path ".\dnsmasq_blocklist.txt" }
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$tmp = Get-Content -Path $list | Select-String -pattern '[\!\^&\[\]#]' -notmatch  
$results = foreach ($line in $tmp) {
    $domain = $line -replace '[|\^]', ''
    "$prefix$domain$suffix"
}
$results | sort-object -unique | Set-Content -Path ".\dnsmasq_blocklist.txt"
$sorted_list = (Get-Content ".\dnsmasq_blocklist.txt" | Measure-Object -Line).Lines
write-host "Total lines in blocklist: $sorted_list"
write-host "difference is: $($lineCount - $sorted_list)"
$stopwatch.Stop();
write-host "Processing completed in $($stopwatch.Elapsed.TotalSeconds) seconds."