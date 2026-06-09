Install-Module Microsoft.Graph

# Increase the buffer

$MaximumFunctionCount = 32768
$MaximumVariableCount = 10000

Import-Module Microsoft.Graph
Connect-MgGraph
Connect-MgGraph -Scopes "Application.Read.All", "Application.ReadWrite.All"
Get-MgServicePrincipal -Filter "AppId eq '00000002-0000-0ff1-ce00-000000000000'" | select -ExpandProperty ServicePrincipalNames

Get-Command -Module Microsoft.Graph.Users

# You are already connected with Connect-MgGraph
Get-MgContext


#<------------Start------------------------- ADFS with Azure ----------------------------------------------------------->

# 1. Generate a certificate for Microsoft Entra multifactor authentication on each AD FS server

$certbase64 = New-AdfsAzureMfaTenantCertificate -TenantID <tenantID>



# 2. Set the certificate as the new credential against the Azure multifactor authentication Client
Connect-MgGraph -Scopes 'Application.ReadWrite.All'
$servicePrincipalId = (Get-MgServicePrincipal -Filter "appid eq '981f26a1-7f43-403b-a875-f8b09b8cd720'").Id
$keyCredentials = (Get-MgServicePrincipal -Filter "appid eq '981f26a1-7f43-403b-a875-f8b09b8cd720'").KeyCredentials
$certX509 = [System.Security.Cryptography.X509Certificates.X509Certificate2]([System.Convert]::FromBase64String($certBase64))
$newKey = @(@{
    CustomKeyIdentifier = $null
    DisplayName = $certX509.Subject
    EndDateTime = $null
    Key = $certX509.GetRawCertData()
    KeyId = [guid]::NewGuid()
    StartDateTime = $null
    Type = "AsymmetricX509Cert"
    Usage = "Verify"
    AdditionalProperties = $null
})
$keyCredentials += $newKey
Update-MgServicePrincipal -ServicePrincipalId $servicePrincipalId -KeyCredentials $keyCredentials

# 3. Configure the AD FS Farm

Set-AdfsAzureMfaTenant -TenantId <tenant ID> -ClientId 981f26a1-7f43-403b-a875-f8b09b8cd720

#<------------End------------------------- ADFS with Azure ----------------------------------------------------------->

Disconnect-MgGraph





