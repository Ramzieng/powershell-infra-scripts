# 🛠️ PowerShell Infrastructure Scripts

> A curated collection of PowerShell scripts for Microsoft 365, Active Directory, Exchange Online, Microsoft Entra ID, and hybrid infrastructure administration.

**Author:** Ramzi Saleh Alarasi — Senior Infrastructure Architect  
**Focus:** Enterprise hybrid infrastructure | Microsoft 365 | Exchange | Entra ID | Automation  
📍 Riyadh, Saudi Arabia &nbsp;|&nbsp; 🔗 [LinkedIn](https://linkedin.com/in/ramzi-alarasi) &nbsp;|&nbsp; 📧 ramzi.eng88@gmail.com

---

## 📁 Repository Structure

```
powershell-infra-scripts/
│
├── ActiveDirectory/
│   ├── Get-ADUserReport.ps1          # Export AD users with last logon and status
│   ├── Bulk-CreateADUsers.ps1        # Bulk user creation from CSV
│   ├── Disable-InactiveAccounts.ps1  # Find and disable stale accounts
│   └── Get-GPOReport.ps1             # Export all GPO settings to HTML
│
├── ExchangeOnline/
│   ├── Get-MailboxSizeReport.ps1     # Mailbox size and quota report
│   ├── Set-MailboxPermissions.ps1    # Bulk mailbox permission management
│   ├── Get-MessageTraceReport.ps1    # Message trace and delivery report
│   └── Export-MailboxFolderStats.ps1 # Folder-level mailbox statistics
│
├── Microsoft365/
│   ├── Get-M365LicenseReport.ps1     # License assignment and usage report
│   ├── Get-InactiveM365Users.ps1     # Find users with no recent activity
│   ├── Set-ConditionalAccessPolicy.ps1 # Conditional Access policy management
│   └── Get-MFAStatusReport.ps1       # MFA status for all users
│
├── EntraID/
│   ├── Get-EntraIDSignInReport.ps1   # Sign-in log export and analysis
│   ├── Get-StaleDevices.ps1          # Find outdated or non-compliant devices
│   └── Sync-EntraIDConnect.ps1       # Force Entra Connect delta/full sync
│
├── HybridInfrastructure/
│   ├── Get-ServerHealthReport.ps1    # Windows Server health check
│   ├── Get-DiskSpaceReport.ps1       # Disk space across all servers
│   ├── Test-ADReplication.ps1        # AD replication health check
│   └── Get-ServiceStatus.ps1         # Critical services status across servers
│
└── Utilities/
    ├── Send-HTMLReport.ps1            # Send formatted HTML reports by email
    ├── Write-Log.ps1                  # Reusable logging function
    └── Connect-AllM365Services.ps1    # Connect to all M365 services in one step
```

---

## 🚀 Getting Started

### Prerequisites

- PowerShell 5.1 or PowerShell 7+
- Required modules (install before running):

```powershell
# Microsoft 365 and Azure modules
Install-Module -Name ExchangeOnlineManagement -Force
Install-Module -Name Microsoft.Graph -Force
Install-Module -Name AzureAD -Force
Install-Module -Name MSOnline -Force

# Active Directory (Windows Server or RSAT)
Import-Module ActiveDirectory
```

### Connecting to Services

```powershell
# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName admin@yourdomain.com

# Connect to Microsoft Graph (for Entra ID, Intune, M365)
Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All"

# Connect to all M365 services at once
.\Utilities\Connect-AllM365Services.ps1
```

---

## 📋 Script Examples

### Get all M365 licensed users and their last sign-in

```powershell
# Microsoft365/Get-InactiveM365Users.ps1
Connect-MgGraph -Scopes "User.Read.All", "AuditLog.Read.All"

$Users = Get-MgUser -All -Property DisplayName, UserPrincipalName, SignInActivity, AssignedLicenses |
    Where-Object { $_.AssignedLicenses.Count -gt 0 }

$Report = $Users | Select-Object DisplayName, UserPrincipalName,
    @{N="LastSignIn"; E={ $_.SignInActivity.LastSignInDateTime }} |
    Sort-Object LastSignIn

$Report | Export-Csv "InactiveUsers_$(Get-Date -Format yyyyMMdd).csv" -NoTypeInformation
Write-Host "Report saved." -ForegroundColor Green
```

---

### Get MFA status for all users

```powershell
# Microsoft365/Get-MFAStatusReport.ps1
Connect-MgGraph -Scopes "UserAuthenticationMethod.Read.All", "User.Read.All"

$Users = Get-MgUser -All -Property DisplayName, UserPrincipalName

$Report = foreach ($User in $Users) {
    $Methods = Get-MgUserAuthenticationMethod -UserId $User.Id
    [PSCustomObject]@{
        DisplayName       = $User.DisplayName
        UPN               = $User.UserPrincipalName
        MFAMethodCount    = $Methods.Count
        MFAEnabled        = if ($Methods.Count -gt 1) { "Yes" } else { "No" }
    }
}

$Report | Export-Csv "MFAStatusReport_$(Get-Date -Format yyyyMMdd).csv" -NoTypeInformation
Write-Host "MFA report exported." -ForegroundColor Green
```

---

### Check AD replication health across all domain controllers

```powershell
# HybridInfrastructure/Test-ADReplication.ps1
Import-Module ActiveDirectory

$DomainControllers = Get-ADDomainController -Filter *

foreach ($DC in $DomainControllers) {
    Write-Host "`nChecking replication on: $($DC.Name)" -ForegroundColor Cyan
    $Result = repadmin /showrepl $DC.Name 2>&1
    if ($Result -match "error|fail") {
        Write-Warning "Replication issue detected on $($DC.Name)"
    } else {
        Write-Host "Replication OK on $($DC.Name)" -ForegroundColor Green
    }
}
```

---

### Export mailbox size report — Exchange Online

```powershell
# ExchangeOnline/Get-MailboxSizeReport.ps1
Connect-ExchangeOnline -UserPrincipalName admin@yourdomain.com

$Mailboxes = Get-Mailbox -ResultSize Unlimited
$Report = foreach ($Mailbox in $Mailboxes) {
    $Stats = Get-MailboxStatistics -Identity $Mailbox.UserPrincipalName
    [PSCustomObject]@{
        DisplayName   = $Mailbox.DisplayName
        UPN           = $Mailbox.UserPrincipalName
        MailboxType   = $Mailbox.RecipientTypeDetails
        TotalSizeGB   = [math]::Round(($Stats.TotalItemSize.Value.ToBytes() / 1GB), 2)
        ItemCount     = $Stats.ItemCount
        QuotaGB       = $Mailbox.ProhibitSendReceiveQuota
    }
}

$Report | Sort-Object TotalSizeGB -Descending |
    Export-Csv "MailboxSizeReport_$(Get-Date -Format yyyyMMdd).csv" -NoTypeInformation
Write-Host "Mailbox report exported." -ForegroundColor Green
```

---

## 🔒 Security Notes

- Never hardcode credentials in scripts — use `Get-Credential` or a secrets vault
- Use service principals with least-privilege permissions where possible
- All scripts are designed for administrative use only
- Test in a non-production environment before running in production
- Log all changes made by scripts using the included `Write-Log.ps1` utility

---

## 📦 Modules Reference

| Module | Purpose | Install Command |
|---|---|---|
| ExchangeOnlineManagement | Exchange Online management | `Install-Module ExchangeOnlineManagement` |
| Microsoft.Graph | Entra ID, Intune, M365 | `Install-Module Microsoft.Graph` |
| AzureAD | Azure AD (legacy) | `Install-Module AzureAD` |
| ActiveDirectory | On-premises AD | Included with RSAT or Windows Server |
| MSOnline | M365 (legacy) | `Install-Module MSOnline` |

---

## 👤 About the Author

**Ramzi Saleh Alarasi** — Senior Infrastructure Architect with 10+ years of experience managing enterprise hybrid cloud and on-premises infrastructure across Microsoft 365, Exchange, Active Directory, Entra ID, Nutanix, and VMware environments.

These scripts reflect real-world administration tasks used in enterprise environments.

🔗 [LinkedIn Profile](https://linkedin.com/in/ramzi-alarasi)  
📧 ramzi.eng88@gmail.com  
📍 Riyadh, Saudi Arabia

---

## ⭐ Contributing

Scripts are maintained for personal and professional reference. If you find them useful, feel free to star the repository.

---

*Last updated: June 2026*
