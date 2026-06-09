# Import the Active Directory module
Import-Module ActiveDirectory

# Import the CSV file containing the OU details
$OUs = Import-Csv -Path "C:\nournet\ous.csv"

# Loop through each row in the CSV and create the OU
foreach ($OU in $OUs) {
    # Create the OU in the specified path
    New-ADOrganizationalUnit -Name $OU.Name -Path $OU.Path
}
