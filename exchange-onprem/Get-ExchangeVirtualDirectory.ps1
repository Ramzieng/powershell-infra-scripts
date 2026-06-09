<#
.Synopsis
   Get-ExchangeVirtualDirectory - Gathers all Exchange virtual directories
.DESCRIPTION
   Gathers all Exchange Virtual Directories. Virtual Directories gathered:
    OWA
    ECP
    ActiveSync
    EWS
    OAB
    MAPI
    Outlook Anywhere
    CAS
.EXAMPLE
    .\Get-ExchangeVirtualDirectory
.EXAMPLE
    .\Get-ExchangeVirtualDirectory -ExportCSV C:\Temp\VirtualDirectories.csv
.PARAMETER VerboseMode
    Outputs results to console
.PARAMETER ExportCSV
    Path to export CSV to with -NoTypeInformation
.NOTES
    Written by Jeremy Corbello

    * Website:    https://www.jeremycorbello.com
    * Twitter:    https://twitter.com/JeremyCorbello
    * LinkedIn:   https://www.linkedin.com/in/jacorbello/
    * Github:     https://github.com/jacorbello

    Change Log:
    V1.0 - 01/05/2018  - Initial Version
#>
[CmdletBinding()]
param (
        [Parameter(Mandatory=$false)]
        [string]$VerboseMode,

        [Parameter(Mandatory=$false)]
        [string]$ExportCSV = $null
        )

#Add Exchange snapin if not already loaded in the PowerShell session
if (Test-Path $env:ExchangeInstallPath\bin\RemoteExchange.ps1)
{
    . $env:ExchangeInstallPath\bin\RemoteExchange.ps1
    Connect-ExchangeServer -auto -AllowClobber
    Write-Host "Established Remote Exchange Session"
}
else
{
    Write-Warning "Exchange Server management tools are not installed on this computer."
    EXIT
}

$servers = Get-ExchangeServer
$data = @()

foreach ($server in $servers) {
    $owa = Get-OwaVirtualDirectory -Server $($server.name) | Select-Object InternalUrl,ExternalUrl
    $ecp = Get-EcpVirtualDirectory -Server $($server.name) | Select-Object InternalUrl,ExternalUrl
    $actSync = Get-ActiveSyncVirtualDirectory -Server $($server.name) | Select-Object InternalUrl,ExternalUrl
    $webServ = Get-WebServicesVirtualDirectory -Server $($server.name) | Select-Object InternalUrl,ExternalUrl
    $oab = Get-OabVirtualDirectory -Server $($server.name) | Select-Object InternalUrl,ExternalUrl
    $mapi = Get-MapiVirtualDirectory -Server $($server.name) | Select-Object InternalUrl,ExternalUrl
    $oAny = Get-OutlookAnywhere -Server $($server.name) | Select-Object ExternalHostname,InternalHostname,ExternalClientsRequireSsl,InternalClientsRequireSsl
    $autoDiscover = Get-ClientAccessServer -Identity $($server.name) | Select-Object AutoDiscoverServiceInternalUri -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    $obj = New-Object PSObject
    $obj | Add-Member -Type NoteProperty -Name Server -Value ($server.name)
    $obj | Add-Member -Type NoteProperty -Name OwaInternalUrl -Value ($owa.InternalUrl)
    $obj | Add-Member -Type NoteProperty -Name OwaExternalUrl -Value ($owa.ExternalUrl)
    $obj | Add-Member -Type NoteProperty -Name EcpInternalUrl -Value ($ecp.InternalUrl)
    $obj | Add-Member -Type NoteProperty -Name EcpExternalUrl -Value ($ecp.ExternalUrl)
    $obj | Add-Member -Type NoteProperty -Name ActiveSyncInternalUrl -Value ($actSync.InternalUrl)
    $obj | Add-Member -Type NoteProperty -Name ActiveSyncExternalUrl -Value ($actSync.ExternalUrl)
    $obj | Add-Member -Type NoteProperty -Name WebServicesInternalUrl -Value ($webServ.InternalUrl)
    $obj | Add-Member -Type NoteProperty -Name WebServicesExternalUrl -Value ($webServ.ExternalUrl)
    $obj | Add-Member -Type NoteProperty -Name OabInternalUrl -Value ($oab.InternalUrl)
    $obj | Add-Member -Type NoteProperty -Name OabExternalUrl -Value ($oab.ExternalUrl)
    $obj | Add-Member -Type NoteProperty -Name MapiInternalUrl -Value ($mapi.InternalUrl)
    $obj | Add-Member -Type NoteProperty -Name MapiExternalUrl -Value ($mapi.ExternalUrl)
    $obj | Add-Member -Type NoteProperty -Name OutlookAnywhereExternalHostname -Value ($oAny.ExternalHostname)
    $obj | Add-Member -Type NoteProperty -Name OutlookAnywhereExternalClientsRequireSsl -Value ($oAny.ExternalClientsRequireSsl)
    $obj | Add-Member -Type NoteProperty -Name OutlookAnywhereInternalHostname -Value ($oAny.InternalHostname)
    $obj | Add-Member -Type NoteProperty -Name OutlookAnywhereInternalClientsRequireSsl -Value ($oAny.InternalClientsRequireSsl)
    $obj | Add-Member -Type NoteProperty -Name AutoDiscoverServiceInternalUri -Value ($autoDiscover.AutoDiscoverServiceInternalUri)
    $data += $obj
}

if ($VerboseMode) {
    $data | Format-List
}
if ($ExportCSV -ne $null) {
    $data | Export-Csv -Path $ExportCSV -NoTypeInformation
}