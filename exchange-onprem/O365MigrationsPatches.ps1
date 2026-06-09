# Connect to Exchange Online
Connect-ExchangeOnline

Get-Mailbox shaik.moiz| Format-List ExchangeGUID

Get-Mailbox shaik.moiz| Format-List ArchiveGUID

Get-Mailbox -Identity "testexch" | Format-List ArchiveGUID



Get-MigrationBatch -Identity "Final-Batch"  -IncludeReport

Set-MigrationBatch -Identity "Final-Batch" -ApproveSkippedItems

Get-MigrationUser | Where-Object {$_.Status -eq "NeedsApproval"} | Set-MigrationUser -ApproveSkippedItems



 Get-MigrationBatch -Identity "YourMigrationBatchName" -IncludeReport

 Set-MoveRequest -Identity "Test-1" -Clear PrimaryOnly

 New-MoveRequest -Identity "Test-10"


New-MoveRequest -Identity "Test-1" -PrimaryOnly $false

New-MoveRequest -Identity "Test-1" -PrimaryOnly

Get-Mailbox -Identity "Test-1"


