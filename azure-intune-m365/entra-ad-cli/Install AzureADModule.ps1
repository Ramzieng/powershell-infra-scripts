Install-Module AzureAD
Import-Module AzureAD
Connect-AzureAD
Get-AzureADUser -ObjectId user@onmicrosoft.com | Select-Object UserPrincipalName
Set-AzureADUser -ObjectId user@onmicrosoft.com -UserPrincipalName user@customdomain.com