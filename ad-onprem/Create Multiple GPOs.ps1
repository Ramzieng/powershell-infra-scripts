# 03-NTP Server policy
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
 
$path = "HKLM\SOFTWARE\Policies\Microsoft\W32Time\TimeProviders\NtpClient"
$pathp = "HKLM\SOFTWARE\Policies\Microsoft\W32Time\Parameters"
$gpname = "03-NTP Server"
$comment = "This GPO for setting UP the Server NTP Policy"
New-GPO -Name $gpname -Comment $comment
Set-GPRegistryValue -Name $gpname -Key $pathp -ValueName "NtpServer" -Type String -Value "10.217.169.193,0x9"; # needs to change the IP of getway only 10.217.169.193
Set-GPRegistryValue -Name $gpname -Key $pathp -ValueName "Type" -Type String -Value "NTP";
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "CrossSiteSyncFlags" -Type DWord -Value 2;
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "ResolvePeerBackoffMinutes" -Type DWord -Value 15;
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "ResolvePeerBackoffMaxTimes" -Type DWord -Value 7;
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "SpecialPollInterval" -Type DWord -Value 1024;
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "EventLogFlags" -Type DWord -Value 0;
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "Enabled" -Type DWord -Value 1;
 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
# 04-NTP Client policy
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
 
$path = "HKLM\SOFTWARE\Policies\Microsoft\W32Time\TimeProviders\NtpClient"
$pathSrv = "HKLM\SOFTWARE\Policies\Microsoft\W32Time\TimeProviders\NtpServer"
$pathp = "HKLM\SOFTWARE\Policies\Microsoft\W32Time\Parameters"
$gpname = "04-NTP Client"
$comment = "This GPO for setting UP the Client NTP Policy"
New-GPO -Name $gpname -Comment $comment
Set-GPRegistryValue -Name $gpname -Key $pathp -ValueName "NtpServer" -Type String -Value "NAMI-PRD-AD01.nami3dp.local,0x9"; # needs to change the Domain of getway only NAMI-PRD-AD01.nami3dp.loca
Set-GPRegistryValue -Name $gpname -Key $pathp -ValueName "Type" -Type String -Value "NTP";
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "CrossSiteSyncFlags" -Type DWord -Value 2;
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "ResolvePeerBackoffMinutes" -Type DWord -Value 15;
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "ResolvePeerBackoffMaxTimes" -Type DWord -Value 7;
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "SpecialPollInterval" -Type DWord -Value 1024;
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "EventLogFlags" -Type DWord -Value 0;
Set-GPRegistryValue -Name $gpname -Key $pathSrv   -ValueName "Enabled" -Type DWord -Value 1;
 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
# 05-Service Accounts
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
$comment = "This GPO for setting UP service accounts Policy"
$gpname = "05-Service Accounts"
New-GPO -Name $gpname -Comment $comment
 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
# 06-Disable Windows Update Automatically
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
$comment = "This GPO for disabling Auto update Policy"
$gpname = "06-Disable Windows Update Automatically"
New-GPO -Name $gpname -Comment $comment
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "NoAutoUpdate" -Type DWord -Value 1;
 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
# 07-Security Logs Size & Audit Logs
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
 
$path = "HKLM\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"
$comment = "This GPO for logs Policy"
$gpname = "07-Security Logs Size & Audit Logs"
New-GPO -Name $gpname -Comment $comment
Set-GPRegistryValue -Name $gpname -Key $path   -ValueName "MaxSize" -Type DWord -Value 5194240;
 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
# 08-Deny RDP
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
$comment = "This GPO for deny RDP Policy"
$gpname = "08-Deny RDP"
New-GPO -Name $gpname -Comment $comment
 
 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
# 09-Allow RDP
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
$comment = "This GPO for allow RDP Policy"
$gpname = "09-Allow RDP"
New-GPO -Name $gpname -Comment $comment
 
 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
# 10-Workstations Locat Admin
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
$comment = "This GPO for setting locaL ADMIN IN MACHINES Policy"
$gpname = "10-Workstations Locat Admin"
New-GPO -Name $gpname -Comment $comment
 
 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
# 11-Servers Local Admin
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------------------------------
$comment = "This GPO for setting UP local admin in servers Policy"
$gpname = "11-Servers Locat Admin"
New-GPO -Name $gpname -Comment $comment