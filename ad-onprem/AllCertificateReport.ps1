$a = "<style>"
$a = $a + "BODY{background-color:#FFFFFF;color: #16894E;font-family:'Segoe UI',Arial,sans-serif;font-size:17px;}"
$a = $a + "BODY h1{text-align: center;margin-bottom:80px; margin-top:50px; }"
$a = $a + "TABLE{border-width: 6px;border-style: solid;border-color: #000000;border-collapse: collapse;margin-right:auto; margin-left:auto;}"
$a = $a + "TH{border-width: 1px;padding: 3px;border-style: solid;border-color: #000000;background-color:#cf1515;color: #FFFFFF; padding:10px;}"
$a = $a + "TD{border-width: 1px;padding: 8px;border-style: solid;border-color: #000000;background-color:#FFFFFF; color: black; padding:10px;}"
$a = $a + "#logo{float: right;padding-right: 20px;}"
$a = $a + "#vision{float: left;padding-left: 20px;}"
$a = $a + "</style>"


$myDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$servers = gc "C:\Nournet\TaskScheduler\AllCertificateReport\serverlist.txt" | Get-ADComputer

$XDArray=Invoke-Command -ComputerName $servers.name {
$Threshold = 60
$Allcertificates = Get-ChildItem -Path Cert:\LocalMachine\my


foreach ($Cert in $Allcertificates) {
    If ($Cert.NotAfter -lt (Get-Date).AddDays($Threshold)) {
        $Daysleft = $Cert.NotAfter - (get-date)
        $Cert | select @{Name="Subject";Expression={((($cert.Subject -split ",")[0]) -split "=")[1]}},FriendlyName,@{n='DaysLeft';e={$Daysleft.Days}},@{Name="Expires";Expression={($cert.NotAfter)}},@{Name="Server";Expression={(hostname)}},@{Name="Issuer";Expression={((($cert.Issuer -split ",")[0]) -split "=")[1]}}
    }
}
}
$Resulta= $XDArray |Select-Object -Property * -ExcludeProperty PSComputerName,RunspaceID,PSShowComputerName|ConvertTo-HTML -head $a
$Resulta |Out-File "$myDir\First.html"
$Result1= gc "$myDir\First.html"


#the below is for the secound result 

$b = "<style>"
$b = $b + "BODY{background-color:#FFFFFF;color: #16894E;font-family:'Segoe UI',Arial,sans-serif;font-size:17px;}"
$b = $b + "BODY h1{text-align: center;margin-bottom:80px; margin-top:50px; }"
$b = $b + "TABLE{border-width: 6px;border-style: solid;border-color: #000000;border-collapse: collapse;margin-right:auto; margin-left:auto;}"
$b = $b + "TH{border-width: 1px;padding: 3px;border-style: solid;border-color: #000000;background-color:#1525d6;color: #FFFFFF; padding:10px;}"
$b = $b + "TD{border-width: 1px;padding: 8px;border-style: solid;border-color: #000000;background-color:#FFFFFF; color: black; padding:10px;}"
$b = $b + "#logo{float: right;padding-right: 20px;}"
$b = $b + "#vision{float: left;padding-left: 20px;}"
$b = $b + "</style>"


$myDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$servers = gc "C:\Nournet\TaskScheduler\AllCertificateReport\serverlist.txt" | Get-ADComputer

$XDArray=Invoke-Command -ComputerName $servers.name {
$Threshold = 200000
$bllcertificates = Get-ChildItem -Path Cert:\LocalMachine\my


foreach ($Cert in $bllcertificates) {
    If ($Cert.NotAfter -lt (Get-Date).AddDays($Threshold)) {
        $Daysleft = $Cert.NotAfter - (get-date)
        $Cert | select @{Name="Subject";Expression={((($cert.Subject -split ",")[0]) -split "=")[1]}},FriendlyName,@{n='DaysLeft';e={$Daysleft.Days}},@{Name="Expires";Expression={($cert.NotAfter)}},@{Name="Server";Expression={(hostname)}},@{Name="Issuer";Expression={((($cert.Issuer -split ",")[0]) -split "=")[1]}}
    }
}
}
$Resultb= $XDArray |Select-Object -Property * -ExcludeProperty PSComputerName,RunspaceID,PSShowComputerName|ConvertTo-HTML -head $b
$Resultb | Out-File "$myDir\secound.html"
$Result2= gc "$myDir\secound.html"


#below for SMTP

$HTMLmessage = @"
$Resulta
$Resultb
"@


$runDateTime = Get-Date    
$smtp = "jcd-ryprd-ex01.jcd.com.sa"    
$to = "ms-support@nour.net.sa","melshamy@nour.net.sa","team1@nour.net.sa"
$from = "CertificateReport@jcd.com.sa"        
$subject = "JCD Servers Certificate - $runDateTime"    
#$attachmentLocation = "$myDir\CertificateReport.html"     

$body = ("{0}<br /><br />{1}" -f -join $Result1, "Below are all Servers Certificates") 
$body += ("{0}<br /><br />{1}" -f -join $Result2, "Thanks .....")  
#$body = "<b>Dear NourNet MS-Support Team</b>, <br><br>"
#$body = $Result1
##$body += $htmlreport 
#$body += $Result 
      
 
Send-MailMessage -SmtpServer $smtp -To $to -From $from -Subject $subject -Body $body -BodyAsHtml 
#-Attachments $attachmentLocation  
