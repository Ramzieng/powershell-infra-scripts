# Import users from csv file   
Import-Csv C:\Nournet\UpdateUser.csv |  ForEach-Object {          
#Read data from CSV File & assign values to parameters 
$SamAccountName = $_. "Email" # the uniqe name for the user
$EmailID = $_. "EmailID"        
$Dept = $_. "Department"  
$Company = $_. "Company"
$Phone = $_. "Phone"         
$Dname = $_. "DisplayName"  
$Fname = $_. "Firstname" 
$Sname = $_. "Surname"        
$mobile = $_. "mobile"         
$title = $_. "Title"         
$location = $_. "Location"         
$manager = $_. "MangerL"  
$m="halshmasi"        
$country = $_. "Country"    

#read the whole properties of the user object and save it in parameter   
$user = Get-ADUser -Identity $SamAccountName  # will use it only when needs to rename the user
#$user1 = Get-ADUser -Identity $manager           
#set Department,ipphone,mobile,city,Email,company,manager,displayname,rename the user object,firstname,lastname and job title values         
#Set-ADUser -Identity $SamAccountName -Replace @{ipPhone = $Phone}     
#Set-ADUser -Identity $SamAccountName -Replace @{mobile = $mobile}     
#Set-ADUser -Identity $SamAccountName -Replace @{department = $Dept}     
#Set-ADUser -Identity $SamAccountName -Replace @{l = $location}     
#Set-ADUser -Identity $SamAccountName -Replace @{mail = $EmailID}    
#Set-ADUser -Identity $SamAccountName -Replace @{company = $Company}    
#Set-ADUser -Identity $SamAccountName -Manager $manager       
#Set-ADUser -Identity $SamAccountName -Replace @{displayName = $Dname}    
#Rename-ADObject -Identity $user.DistinguishedName -NewName $Dname      
#Set-ADUser -Identity $SamAccountName -Replace @{GivenName = $Fname}  
#Set-ADUser -Identity $SamAccountName -Replace @{sn = $Sname}   
#Set-ADUser -Identity $SamAccountName -Replace @{title  = $title}          
#Set-ADUser -Identity $samAccountName -Office "$Office"   


Write-Host " Active Directory account Data updated for : " $samAccountName     }     
