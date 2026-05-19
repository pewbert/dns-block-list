param (
    [Parameter(Mandatory=$false)]
    [string]$url,
    [Parameter(Mandatory=$false)]
    [string]$list,
    [Parameter(Mandatory=$true)]
    [string]$filter,
    [Parameter(Mandatory=$true)]
    [string]$out_file

)
$ipaddr ='\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b' #regex for a valid ipv4 address
#create the raw list of hostnames from url file
if ($url) {
    $files = Get-Content -Path "$url"
    foreach ($f in $files) {
        Invoke-WebRequest -uri "$f" | Add-Content -Path ".\list.txt"
    }
    $list = Get-ChildItem -Path ".\list.txt" | Select-Object -ExpandProperty Name
}
if ($list) {
        $tmp = Get-Content -Path ".\$list" | Select-String -pattern '(#)|([)|(])|(!)' -notmatch  #strip all comments and bracket blocks from entire file
        #remove the unnecessary crap and format the list for adblock-plus or hosts file format.
        if ($filter -eq "adblock") {
            $unsorted = $tmp -replace $ipaddr,"" -replace '(^\s+|\s+$)','' -replace '\s+','' | ForEach-Object{"||$_^"} #remove spaces and ip addresses, change format to adblock-plus eg. ||domain.example.com^ 
            $unsorted | sort-object -Unique > $out_file #sorted and duplicates removed
        }
        elseif ($filter -eq "hosts") {
            $unsorted = $tmp -replace $ipaddr,"" -replace '(^\s+|\s+$)','' -replace '\s+','' | ForEach-Object{"0.0.0.0 $_"} #remove spaces and ip addresses, change format to /etc/hosts file format
            $unsorted | sort-object -Unique > $out_file #sorted and duplicates removed
        }
        else {
            Write-Host "Invalid filter option. Please choose either 'adblock' or 'hosts' and try again."
            exit
        }
}
elseif (-not (Test-Path -Path ".\$list") ) {
        Write-Host "File list: $list does not exist. Please check the path and try again."
        exit
        }
else { write-host "wtf"} 

