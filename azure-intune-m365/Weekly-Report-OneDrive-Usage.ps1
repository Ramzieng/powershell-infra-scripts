$tenantId = ""
$clientId = ""
$clientSecret = ""
$body = @{
    grant_type    = "client_credentials"
    scope         = "https://graph.microsoft.com/.default"
    client_id     = $clientId
    client_secret = $clientSecret
}
$response = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -ContentType "application/x-www-form-urlencoded" -Body $body

$token = $response.access_token

# Convert the token to a SecureString
$secureToken = ConvertTo-SecureString $token -AsPlainText -Force

# Connect to Microsoft Graph
Connect-MgGraph -AccessToken $secureToken


$path = "C:\MailboxReport-v3.csv"
#Get-MgReportMailboxUsageDetail -Period D7 -OutFile $path
#Get-MgReportOneDriveUsageAccountDetail -Period D7 -OutFile $path
$report = Get-MgReportOneDriveUsageAccountDetail -Period D7 -OutFile $path


$userDetails = @{}
foreach ($user in $report) {
    $userId = $user.UserPrincipalName
    $userDetails[$userId] = Get-MgUser -UserId $userId
}

# Add usernames to the report
foreach ($user in $report) {
    $user.UserPrincipalName = $userDetails[$user.UserPrincipalName].DisplayName
}

# Export the updated report
$report | Export-Csv -Path "C:\OneDriveUsageReport.csv" -NoTypeInformation


#$report = import-csv $path
#$report.Foreach({
 #   $_."storage used (Byte)" = '{0:N2} MB' -f ($_."storage used (Byte)" / 1MB)
#})
#$report | Export-CSV -Path $path -NoTypeInformation

$email = @{
    Message = @{
        Subject = "Weekly OneDrive Usage Report"
        Body = @{
            ContentType = "Text"
            Content = "Please find the attached OneDrive usage report."
        }
        ToRecipients = @(
            @{
                EmailAddress = @{
                    Address = "ramzi@hadish.online"
                }
            }
        )
        Attachments = @(
            @{
                "@odata.type" = "#microsoft.graph.fileAttachment"
                Name = "MailboxReport-v3.csv"
                ContentBytes = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($path))
            }
        )
    }
    SaveToSentItems = $false
}
Send-MgUserMail -UserId "r.alarasi@hadish.online" -BodyParameter $email


Disconnect-MgGraph