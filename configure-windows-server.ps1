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


