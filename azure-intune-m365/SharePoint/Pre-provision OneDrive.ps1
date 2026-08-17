#From another script, this is the code to install the SharePoint Online Management Shell module if it is not already installed.

Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Verbose
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

#check if the module is already installed
Get-Module -Name Microsoft.Online.SharePoint.PowerShell -ListAvailable | Select Name,Version

Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force

Import-Module -Name Microsoft.Online.SharePoint.PowerShell

Connect-SPOService -Url https://saevllc-admin.sharepoint.com/

# 1. Import the CSV and strip out any blank/empty rows
$allUsers = (Import-Csv -Path "C:\users.csv").Email | Where-Object { ![string]::IsNullOrWhiteSpace($_) }

Write-Host "Found $($allUsers.Count) valid email addresses." -ForegroundColor Yellow

# 2. Set a smaller batch size to prevent server timeouts (50 is usually safe)
$batchSize = 50
$batchCount = [math]::Ceiling($allUsers.Count / $batchSize)

# 3. Loop through and process in smaller chunks
for ($i = 0; $i -lt $batchCount; $i++) {
    
    # Get the next batch
    $batch = $allUsers | Select-Object -Skip ($i * $batchSize) -First $batchSize
    
    Write-Host "Submitting batch $($i + 1) of $batchCount ($($batch.Count) users)..." -ForegroundColor Cyan
    
    try {
        # Attempt to request the sites
        Request-SPOPersonalSite -UserEmails @($batch)
        Write-Host "Batch $($i + 1) submitted successfully!" -ForegroundColor Green
    }
    catch {
        # If it times out again, it will catch the error and keep going
        Write-Host "Error on batch $($i + 1): $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # Pause for 10 seconds between batches to let the Microsoft servers breathe
    if ($i -lt ($batchCount - 1)) {
        Start-Sleep -Seconds 10
    }
}

Write-Host "Script finished!" -ForegroundColor Green

