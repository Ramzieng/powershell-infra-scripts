#-------------------------------------------------
Connect-SPOService -Url https://saevllc-admin.sharepoint.com/

# 1. Set your tenant name (based on your previous admin URL)
$tenantName = "saevllc"

# 2. Import the CSV and clean empty rows
$allUsers = (Import-Csv -Path "C:\users.csv").Email | Where-Object { ![string]::IsNullOrWhiteSpace($_) }

# Array to hold the final results
$report = @()

Write-Host "Starting verification for $($allUsers.Count) users..." -ForegroundColor Cyan

# 3. Loop through each user to check their OneDrive site status
foreach ($email in $allUsers) {
    
    # Format the email into the SharePoint OneDrive URL format 
    # Example: user@domain.com becomes user_domain_com
    $urlFormattedEmail = $email.Replace("@", "_").Replace(".", "_").Replace("-", "_")
    $oneDriveUrl = "https://$tenantName-my.sharepoint.com/personal/$urlFormattedEmail"

    try {
        # Try to retrieve the site. We hide the red error output using ErrorAction Stop
        $site = Get-SPOSite -Identity $oneDriveUrl -ErrorAction Stop
        
        Write-Host "[READY] $email" -ForegroundColor Green
        $status = "Provisioned"
    }
    catch {
        Write-Host "[PENDING] $email" -ForegroundColor Yellow
        $status = "Not Provisioned"
    }

    # Add the result to our report
    $report += [PSCustomObject]@{
        Email       = $email
        Status      = $status
        OneDriveUrl = $oneDriveUrl
    }
}

# 4. Export the results to a new CSV file
$reportPath = "C:\OneDrive_Verification_Report.csv"
$report | Export-Csv -Path $reportPath -NoTypeInformation

Write-Host "`nVerification complete! You can view the full report at: $reportPath" -ForegroundColor Green