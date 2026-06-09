# Connect to Exchange Online
Connect-ExchangeOnline

# Import the list of users from a CSV file
$users = Import-Csv -Path "C:\Osooltest.csv"

# Create an empty array to store the results
$results = @()

# Loop through each user in the CSV
# Loop through each user in the CSV
foreach ($user in $users) {
    # Try to get the mailbox details
    $mailbox = Get-Mailbox -Identity $user.UserPrincipalName -ErrorAction SilentlyContinue

    if ($mailbox) {
        # Create a custom object with the user's details
        $userDetails = [PSCustomObject]@{
            UserPrincipalName = $user.UserPrincipalName
            ExchangeGUID = $mailbox.ExchangeGUID
            ArchiveGUID = $mailbox.ArchiveGUID
        }
    } else {
        # Create a custom object indicating the mailbox does not exist
        $userDetails = [PSCustomObject]@{
            UserPrincipalName = $user.UserPrincipalName
            ExchangeGUID = "Not Exist"
            ArchiveGUID = "Not Exist"
        }
    }

    # Add the user's details to the results array
    $results += $userDetails
}

# Export the results to a new CSV file
$results | Export-Csv -Path "C:\OsoolusersGUIDs-100.csv" -NoTypeInformation

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false