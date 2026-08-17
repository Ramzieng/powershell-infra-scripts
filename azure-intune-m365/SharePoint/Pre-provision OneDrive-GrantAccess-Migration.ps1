

# 1. Configuration
$tenantName = "saevllc"
# IMPORTANT: Enter the Admin Email address you are using inside MigrationWiz
$migrationAdmin = "nn-cloud@ARAMCOVENTURES.COM" 

# 2. Import CSV and prepare report
$allUsers = (Import-Csv -Path "C:\users.csv").Email | Where-Object { ![string]::IsNullOrWhiteSpace($_) }
$report = @()

Write-Host "Starting MigrationWiz Fixer for $($allUsers.Count) users..." -ForegroundColor Cyan

foreach ($email in $allUsers) {
    
    $baseFormat = $email.Replace("@", "_").Replace(".", "_").Replace("-", "_")
    $foundUrl = $null
    $status = ""

    # 3. Create a list of URLs to check (Standard, +1, and +2 for recreated accounts)
    $urlsToTest = @(
        "https://$tenantName-my.sharepoint.com/personal/$baseFormat",
        "https://$tenantName-my.sharepoint.com/personal/${baseFormat}1",
        "https://$tenantName-my.sharepoint.com/personal/${baseFormat}2"
    )

    # 4. Hunt for the exact existing URL
    foreach ($url in $urlsToTest) {
        try {
            $site = Get-SPOSite -Identity $url -ErrorAction Stop
            $foundUrl = $site.Url
            break # Stop looking if we found the site!
        }
        catch {
            # Site not found at this URL, loop to test the next variation
        }
    }

    # 5. Take action based on what we found
    if ($foundUrl) {
        Write-Host "[FOUND] $email -> $foundUrl" -ForegroundColor Green
        
        try {
            # Grant the MigrationWiz admin account access to this OneDrive
            Set-SPOUser -Site $foundUrl -LoginName $migrationAdmin -IsSiteCollectionAdmin $True -ErrorAction Stop
            Write-Host "  -> Granted Site Collection Admin rights to $migrationAdmin" -ForegroundColor Cyan
            $status = "Ready for MigrationWiz"
        }
        catch {
            Write-Host "  -> Failed to grant permissions. (Check if admin email is correct)" -ForegroundColor Red
            $status = "Permissions Error"
        }
    } 
    else {
        Write-Host "[NOT INITIALIZED] $email -> Requesting creation now..." -ForegroundColor Yellow
        
        try {
            # Request creation because the site flat out doesn't exist yet
            Request-SPOPersonalSite -UserEmails @($email)
            $status = "Creation Requested (Wait 1-24 hours)"
        }
        catch {
            Write-Host "  -> Failed to request creation: $($_.Exception.Message)" -ForegroundColor Red
            $status = "Creation Failed"
        }
    }

    # 6. Log it
    $report += [PSCustomObject]@{
        UserEmail     = $email
        ExactSiteUrl  = if ($foundUrl) { $foundUrl } else { "N/A" }
        Status        = $status
    }
}

# 7. Export the report
$reportPath = "C:\MigrationWiz_Fix_Report.csv"
$report | Export-Csv -Path $reportPath -NoTypeInformation

Write-Host "`nScript complete! Check the report at: $reportPath" -ForegroundColor Green