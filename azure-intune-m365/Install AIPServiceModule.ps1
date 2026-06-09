Install-Module -Name AIPService
Import-Module -Name AIPService
$PSVersionTable.PSVersion
Connect-AipService
Add-AipServiceRoleBasedAdministrator -EmailAddress ramzi@hadish.online -Role"ConnectorAdministrator"
