# ============================================================
# Message details
# ============================================================
Connect-ExchangeOnline

$Sender     = "cybersecurity@aramcoventures.com"
$Subject    = "Think Before You Share: Aramco Europe Awareness Session"
$TargetDate = "2026-11-02"

# Generate a unique search name
$SearchName = "Think Before You Share- V2" + (Get-Date -Format "yyyyMMdd-HHmmss")

# Exact sender + exact subject + sent date
$ContentQuery = "(from:`"$Sender`") AND (subject:`"$Subject`") AND (sent=$TargetDate)"

Write-Host "Search name:  $SearchName" -ForegroundColor Cyan
Write-Host "Search query: $ContentQuery" -ForegroundColor Cyan

# ============================================================
# 1. Install or update the Exchange Online module
# ============================================================
$Module = Get-Module ExchangeOnlineManagement -ListAvailable |
    Sort-Object Version -Descending |
    Select-Object -First 1

if (-not $Module -or $Module.Version -lt [version]"3.9.0") {
    Write-Host "Installing/updating ExchangeOnlineManagement..." -ForegroundColor Yellow

    Install-Module ExchangeOnlineManagement `
        -Scope CurrentUser `
        -Force `
        -AllowClobber
}

Import-Module ExchangeOnlineManagement -Force

# ============================================================
# 2. Connect to Microsoft Purview Compliance PowerShell
# ============================================================
Connect-IPPSSession -EnableSearchOnlySession

# ============================================================
# 3. Remove any existing search with the same generated name
# ============================================================
$ExistingSearch = Get-ComplianceSearch -Identity $SearchName -ErrorAction SilentlyContinue

if ($ExistingSearch) {
    Remove-ComplianceSearch -Identity $SearchName -Confirm:$false
}

# ============================================================
# 4. Create an organization-wide search
# ============================================================
New-ComplianceSearch `
    -Name $SearchName `
    -ExchangeLocation All `
    -ContentMatchQuery $ContentQuery

# Start the search
Start-ComplianceSearch -Identity $SearchName

# ============================================================
# 5. Wait for the search to complete
# ============================================================
do {
    Start-Sleep -Seconds 10

    $SearchStatus = Get-ComplianceSearch -Identity $SearchName

    Write-Host ("Search status: {0}" -f $SearchStatus.Status) `
        -ForegroundColor Yellow

} while ($SearchStatus.Status -notin @("Completed", "PartiallySucceeded", "Failed"))

# ============================================================
# 6. Display the search result
# ============================================================
$SearchName="Think Before You Share-20261102-095530"
$SearchName="Think Before You Share- V220261102-101507"

$SearchStatus = Get-ComplianceSearch -Identity $SearchName

Write-Host ""
Write-Host "Search completed." -ForegroundColor Green
Write-Host "Search name:       $($SearchStatus.Name)"
Write-Host "Status:            $($SearchStatus.Status)"
Write-Host "Matching items:    $($SearchStatus.Items)"
Write-Host "Estimated size:    $($SearchStatus.Size)"
Write-Host "Success results:   $($SearchStatus.SuccessResults)"
Write-Host ""

if ($SearchStatus.Status -eq "Failed") {
    throw "The compliance search failed. No deletion was performed."
}

if ([int64]$SearchStatus.Items -eq 0) {
    Write-Warning "No matching emails were found. No deletion was performed."
    Disconnect-ExchangeOnline -Confirm:$false
    return
}

# ============================================================
# 7. Require confirmation before deletion
# ============================================================
$Confirmation = Read-Host `
    "Type DELETE to permanently remove the $($SearchStatus.Items) matching item(s)"

if ($Confirmation -cne "DELETE") {
    Write-Warning "Deletion cancelled. The compliance search was retained."
    Disconnect-ExchangeOnline -Confirm:$false
    return
}

# ============================================================
# 8. Hard-delete the matching messages
# ============================================================
$PurgeAction = New-ComplianceSearchAction `
    -SearchName $SearchName `
    -Purge `
    -PurgeType SoftDelete `
    -Confirm:$false

Write-Host ""
Write-Host "Purge action submitted: $($PurgeAction.Name)" `
    -ForegroundColor Green

# ============================================================
# 9. Monitor the purge operation
# ============================================================
do {
    Start-Sleep -Seconds 10

    $PurgeStatus = Get-ComplianceSearchAction `
        -Identity "$SearchName`_Purge" `
        -ErrorAction SilentlyContinue

    if ($PurgeStatus) {
        Write-Host ("Purge status: {0}" -f $PurgeStatus.Status) `
            -ForegroundColor Yellow
    }

} while ($PurgeStatus -and $PurgeStatus.Status -notin @(
    "Completed",
    "PartiallySucceeded",
    "Failed"
))

# Final result
$PurgeStatus | Format-List Name,Status,Results,Errors

Disconnect-ExchangeOnline -Confirm:$false

Get-ComplianceSearchAction -Identity "$SearchName`_Purge" | Select-Object Name, Status, JobEndTime