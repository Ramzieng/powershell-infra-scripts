Install-Module Microsoft.Graph
Import-Module Microsoft.Graph
Connect-MgGraph
Connect-MgGraph -Scopes "Application.Read.All", "Application.ReadWrite.All"
Get-MgServicePrincipal -Filter "AppId eq '00000002-0000-0ff1-ce00-000000000000'" | select -ExpandProperty ServicePrincipalNames


$x = Get-MgServicePrincipal -Filter "AppId eq '00000002-0000-0ff1-ce00-000000000000'"
$x.ServicePrincipalNames += "https://autodiscover.osoolre.com/"
$x.ServicePrincipalNames += "https://mail.osoolre.com"
$x.ServicePrincipalNames += "https://mail.osoolre.com/"
$x.ServicePrincipalNames += "https://autodiscover.osoolre.com"
$x.ServicePrincipalNames += "https://mail.osoolre.com/mapi"
$x.ServicePrincipalNames += "https://mail.osoolre.com/EWS/Exchange.asmx"
$x.ServicePrincipalNames += "https://mail.osoolre.com/OAB"
$x.ServicePrincipalNames += "https://mail.osoolre.com/Autodiscover/Autodiscover.xml"
$x.ServicePrincipalNames += "https://mail.osoolre.com/Microsoft-Server-ActiveSync"
$x.ServicePrincipalNames += "https://autodiscover.osoolre.com/Autodiscover/Autodiscover.xml"
Update-MgServicePrincipal -ServicePrincipalId $x.Id -ServicePrincipalNames $x.ServicePrincipalNames


Get-Command -Module Microsoft.Graph.Users
