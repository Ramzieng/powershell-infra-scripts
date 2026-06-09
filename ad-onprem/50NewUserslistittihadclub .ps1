$ou = "OU=Test-Users,DC=GCDC,DC=local"
$file = 'C:\Nournet\NewScript\GCDC.csv'
$password = "P@ssw0rd@123456!"
 

Import-CSV $file | ForEach {
        $user = New-ADUser `
            -Name ($_.Name) `
            -SamAccountName ($_.samAccountName) `
            -DisplayName ($_.DisplayName) `
	    -Mobile ($_.Mobile) `
            -UserPrincipalName ($_.UserPrincipalName) `
            -GivenName ($_.GivenName) `
            -Surname ($_.Surname) `
	    -Department ($_.Department) `
	    -Title ($_.Title) `
            -Path $ou `
            -AccountPassword (ConvertTo-SecureString -AsPlainText $password -force )`
            -Enabled $true `
            -ChangePasswordAtLogon $true
}