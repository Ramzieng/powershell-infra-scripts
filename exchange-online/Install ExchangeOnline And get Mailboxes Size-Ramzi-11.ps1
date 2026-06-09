# Install the module of Exchange Online
Install-Module -Name ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline


# Retrieve all mailboxes and their statistics
$mailboxes = Get-Mailbox -ResultSize Unlimited

# Loop through each mailbox to gather statistics and archive information
$mailboxStats = $mailboxes | ForEach-Object {
    $mailbox = $_
    $stats = Get-MailboxStatistics -Identity $mailbox.UserPrincipalName
    $archiveStats = if ($mailbox.ArchiveStatus -eq 'Active') {
        Get-MailboxStatistics -Identity $mailbox.UserPrincipalName -Archive
    } else {
        $null
    }
    [PSCustomObject]@{
        DisplayName = $mailbox.DisplayName
        EmailAddress = $mailbox.PrimarySMTPAddress
        TotalItemSize = $stats.TotalItemSize.Value
        ArchiveEnabled = $mailbox.ArchiveStatus -eq 'Active'
       # ArchiveSize = if ($archiveStats) { $archiveStats.TotalItemSize.Value} else { 0 }
    }
}
# Export the results to a CSV file
$mailboxStats | Export-Csv -Path "C:\MailboxSizes-Osoole.csv" -NoTypeInformation