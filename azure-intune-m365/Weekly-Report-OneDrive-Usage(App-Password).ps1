$username = "your-admin@domain.com"
$password = ConvertTo-SecureString "your-app-password" -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $password)
Connect-MgGraph -Credential $creds
