#set execution policy to be remote signed
set-executionpolicy remotesigned -force
Write-Host "Execution policy has been set to remote signed." -ForegroundColor Green


#disable IE ESC
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer
Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
 
#disable ipv6, this only works with 2012 so is commented out for regular 2008 r2 use  ***untested
#get-netadapterbinding | set-NetAdapterBinding -ComponentID ms_tcpip6 -Enabled $false


#disable ipv6 manually, this will open the network connections
Write-Host "Disable IP v6 if required, press any key to open the network connections screen"
$x = $host.UI.RawUI.ReadKey("NoEcho.IncludeKeydown")
ncpa.cpl

#enable remote desktop 
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0

#install ad admin tools
Add-WindowsFeature RSAT-DNS-Server -restartAdd-WindowsFeature RSAT-ADDS-Tools -restart
Add-WindowsFeature RSAT-AD-AdminCenter -restart
Add-WindowsFeature RSAT-SNIS -restart

#disable firewall
netsh advfirewall set domainprofile state off
netsh advfirewall set privateprofile state off
#netsh advfirewall set publicprofie state off

#windows 2012, 
#Import-Module NetSecurity
#Set-NetFirewall -Profile Domain -Enabled $false
#Set-NetFirewall -Profile private -Enabled $false
#Set-NetFirewall -Profile public -Enabled $false
# can use a , between profiles or a * for all profiles

Set google as default search engine
New-Item -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes" -Name "{E654518E-3688-45C9-A3F3-0FD51CADB782}" -Force 
New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes" -Name DefaultScope -PropertyType String -Value "{E654518E-3688-45C9-A3F3-0FD51CADB782}" -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes\{E654518E-3688-45C9-A3F3-0FD51CADB782}" -Name DisplayName -PropertyType String -Value "Google" -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes\{E654518E-3688-45C9-A3F3-0FD51CADB782}" -Name URL -PropertyType String -Value "http://www.google.com/search?q={searchTerms}&sourceid=ie7&rls=com.microsoft:{language}:{referrer:source}&ie={inputEncoding?}&oe={outputEncoding?}" -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes\{E654518E-3688-45C9-A3F3-0FD51CADB782}" -Name ShowSearchSuggestions -PropertyType Binary -Value 1 -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes\{E654518E-3688-45C9-A3F3-0FD51CADB782}" -Name SuggestionsURL -PropertyType String -Value "http://clients5.google.com/complete/search?q={searchTerms}&client=ie8&mw={ie:maxWidth}&sh={ie:sectionHeight}&rh={ie:rowHeight}&inputencoding={inputEncoding}&outputencoding={outputEncoding}" -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes\{E654518E-3688-45C9-A3F3-0FD51CADB782}" -Name OSDFileURL -PropertyType String -Value "http://www.iegallery.com/en-us/AddOns/DownloadAddOn?resourceId=813" -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes\{E654518E-3688-45C9-A3F3-0FD51CADB782}" -Name FaviconURL -PropertyType String -Value "http://www.google.com/favicon.ico" -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\SearchScopes\{E654518E-3688-45C9-A3F3-0FD51CADB782}" -Name FaviconPath -PropertyType String -Value "C:\Users\Administrator\AppData\LocalLow\Microsoft\Internet Explorer\Services\search_{E654518E-3688-45C9-A3F3-0FD51CADB782}.ico" -Force

