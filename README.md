# domain_block_list

Powershell scripts to aggregate domain names for adblocking into 1 file. 
* Converts the no-ip format to either adblock or hosts.
* Removes comments and other information to keep the file clean.
* removes duplicate entries and sorts the file alphanumerically
* takes a lot of time to run through large lists. 

use cases:
> .\noip_to_adblock_or_hosts.ps1 -list noip_hostname.txt -filter hosts -out_file sorted_hosts.list
> 
> .\noip_to_adblock_or_hosts.ps1 -url raw_url_paths.txt -filter hosts -out_file sorted_hosts.list

where url is the path to a file with a list of valid url addresses to lists of domain names.
where list is the path to a file with a list of valid domain names.

if you supply a url then a list will be created.
if you have a list already then provide that and no url will be necessary.

* no-ip as the name implies has no ip addresses and is a list of domain names: >         domain.com
* adblock and adguard begin each line with a double pipe and end with a caret: >       ||domain.com^
* hosts is formatted like /etc/hosts or c:\windows\system32\drivers\etc\hosts: > 0.0.0.0 domain.com

Use it however you like. I don't care.
