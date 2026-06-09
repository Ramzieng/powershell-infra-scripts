Import-Module ActiveDirectory
$Users = Import-Csv -Path "C:\nournet\GCDC.csv"
$password ="Nournet@2030"
$ou = "OU=Test-Users,DC=nournet,DC=local"

foreach ($User in $Users) {
 $SamAccountName        = $User.SamAccountName
 #$department            =$User.Department
 $mobile                =$User.mobile
   # $Parameters = @{
        #SamAccountName        = $User.SamAccountName
        #UserPrincipalName     = "$($User.UserPrincipalName)@nournet.local"
        #Name                  = $User.Name
        #GivenName             = $User.GivenName
        #Surname               = $User.Surname
        #Enabled               = $true
        #ChangePasswordAtLogon = $true
        #title                 =$User.title
        #AccountPassword       = (ConvertTo-SecureString -AsPlainText $password -Force)
        #Path                  = $OU
        #department             =$User.Department
   # }
    Set-ADUser -Identity $SamAccountName -Replace @{mobile = $mobile}
}
Write-Host " Users had been created successfully " -ForegroundColor Green -NoNewline