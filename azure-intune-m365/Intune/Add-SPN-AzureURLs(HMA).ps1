Install-Module Microsoft365DSC -Force -AcceptLicense
Update-M365DSCDependencies

Get-Module -ListAvailable

Export-M365DSCConfiguration -LaunchWebUI

# Getting client credential
$Credential = Get-Credential

# Exporting resources using credentials
Export-M365DSCConfiguration -Components @("IntuneAppConfigurationPolicy") -Credential $Credential

Connect-MgGraph

Uninstall-Module Microsoft.Graph.Authentication -Force
Update-M365DSCDependencies

Get-Module -Name Microsoft.Graph.Authentication -ListAvailable | Uninstall-Module  -Force

Uninstall-Module -Name Microsoft.Graph.Authentication -RequiredVersion 2.36.1 -Force