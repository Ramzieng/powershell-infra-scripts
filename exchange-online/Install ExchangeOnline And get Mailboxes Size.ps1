############################################# Install the Module & Import it ##################################################

# Install the module of Exchange Online
Install-Module -Name ExchangeOnlineManagement

# Import the module of Exchange Online
Import-Module -Name ExchangeOnlineManagement

###############################################################################################################################

################################### - Search the mialboxes size MB & Bytes & checking the archiving Fales & size - ############

###############################################################################################################################

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
        ArchiveSize = if ($archiveStats) { $archiveStats.TotalItemSize.Value.ToMB() } else { 0 }
    }
}
# Export the results to a CSV file
$mailboxStats | Export-Csv -Path "C:\MailboxSizes2.csv" -NoTypeInformation


###############################################################################################################################

################################### - Search the mialboxes size MB  & checking the archiving Fales or True- ###################

###############################################################################################################################

Connect-ExchangeOnline

# Retrieve all mailboxes and their statistics
$mailboxes = Get-Mailbox -ResultSize Unlimited

# Loop through each mailbox to gather statistics
$mailboxStats = $mailboxes | ForEach-Object {
    $mailbox = $_
    $stats = Get-MailboxStatistics -Identity $mailbox.UserPrincipalName
    $totalItemSizeMB = if ($stats.TotalItemSize) {
        [math]::Round(($stats.TotalItemSize.Value.ToString().Split('(')[1].Split(' ')[0] -replace '[^0-9.]', '') / 1MB, 2)
    } else {
        0
    }
    $archiveSizeMB = if ($mailbox.ArchiveStatus -eq 'Active') {
        $archiveStats = Get-MailboxStatistics -Identity $mailbox.UserPrincipalName -Archive
        if ($archiveStats.TotalItemSize) {
            [math]::Round(($archiveStats.TotalItemSize.Value.ToString().Split('(')[1].Split(' ')[0] -replace '[^0-9.]', '') / 1MB, 2)
        } else {
            0
        }
    } else {
        'false'
    }
    [PSCustomObject]@{
        DisplayName = $mailbox.DisplayName
        EmailAddress = $mailbox.PrimarySMTPAddress
        TotalItemSizeMB = $totalItemSizeMB
        ArchiveSizeMB = $archiveSizeMB
    }
}

# Export the results to a CSV file
$mailboxStats | Export-Csv -Path "C:\MailboxSizes.csv" -NoTypeInformation

###############################################################################################################################

###############################################################################################################################

###############################################################################################################################