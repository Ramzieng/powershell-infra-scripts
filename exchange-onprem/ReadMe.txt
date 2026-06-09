
1. General

Name:
Location:
Author:
When running the task use the following account: (organization managment)
Run whether user is logged on or not
Run with highest privileges
Log on as batch
user must be member of Organization Management Group

2. triggers

Begin On schedule
Daily
Start
Recur every

3. Action

start a program 
program/scripts:C:\Windows\system32\windowspowershell\v1.0\powershell.exe
Add arguments :-command C:\Data\Tasks\New-ADPasswordReminder\New-ADPasswordReminder.ps1


