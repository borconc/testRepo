<# 
   Powershell Lab 7
   Name: Connor Bores
   Date: April 16th
   File: PSLab7.ps1
#>
cls
do {
    $answer = "0"

    $choice = Read-Host "Choose from the following menu items:
  A. VIEW one OU `t B. VIEW all OUs
  C. VIEW one OU `t D. VIEW all OUs
  E. VIEW one OU `t F. VIEW all OUs


  G. VIEW one OU `t H. VIEW all OUs
  I. VIEW one OU `t J. VIEW all OUs


  K. VIEW one OU `t L. VIEW all OUs


  M. VIEW one OU `t N. VIEW all OUs


  Enter anything other than A - N to quit "
    
    if ($choice -eq "A"){
      $chosenOU = Read-Host "What is the name of the OU "
      Get-ADOrganizationalUnit -Filter "Name -like '$chosenOU'" | Format-Table -Property Name, DistinguishedName
      pause  
    }
    if ($choice -eq "B"){
        Get-ADOrganizationalUnit -Filter "Name -notlike 'Domain Controllers'" | Format-Table
        pause
    }
    if ($choice -eq "C"){
        $chosenGroup = Read-Host "What is the name of the group "
        Get-ADGroup -Filter "Name -like '$chosenGroup'" | Format-Table -Property Name, GroupScope, GroupCategory
        pause
    }
    if ($choice -eq "D"){
        Get-ADGroup -Filter "Name -like '*'" | Format-Table -Property Name, GroupScope, GroupCategory
        pause
    }
    if ($choice -eq "E"){
        $chosenUser = Read-Host "What is the name of the user "
        Get-ADUser -Filter "Name -like '$chosenUser'" | Format-Table -Property Name, DistinguishedName
        pause
    }

    if ($choice -eq "F"){
        Get-ADUser -Filter "Name -like '*'" | Format-Table -Property Name, DistinguishedName, GivenName, SurName
        pause
    }

    if ($choice -eq "G"){
        $newOUname = read-host "What is the name of the OU you would like to create "
        New-ADOrganizationalUnit -Name "$newOUname" -Path "DC=Adatum, DC=COM"
        Get-ADOrganizationalUnit -Filter "Name -like '$newOUname'" | Format-Table 
        pause  
    }

    if ($choice -eq "H"){
        $newGroupName = Read-Host "What is the name of the group you would like to make "
        New-ADGroup -Name "$newGroupName" -GroupScope Global -GroupCategory Security 
        Get-ADGroup -Filter "Name -like '$newGroupName'" | Format-Table -Property Name, GroupScope, GroupCategory
        pause
    }

    if ($choice -eq "I"){
        $newUserName = Read-Host "What is the name of the user you would like to create "
        $newUserPrincipalName = "$newUserName@$env:USERDOMAIN.com"
        $1 = Read-Host "Please enter their first name "
        $2 = Read-Host "Please enter their last name "
        $3 = Read-Host "Please enter their address "
        $4 = Read-Host "Please enter their city "
        $5 = Read-Host "Please enter their state "
        $6 = Read-Host "Please enter their zip code "
        $7 = Read-Host "Please enter their company "
        $8 = Read-Host "Please enter their division "
        $usersOrOU = Read-Host "Would you like this user in the users directory or in an OU? Type either 'user' or 'OU' "
        if ($usersOrOU -eq "user"){
            New-ADUser -Name "$newUserName" -UserPrincipalName $newUserPrincipalName -GivenName "$1" -Surname "$2" -StreetAddress $3 -City "$4" -State $5 -PostalCode $6 -Company $7 -Division $8 -Path "CN=Users, DC=Adatum, DC=COM" -AccountPassword (ConvertTo-SecureString Password01 -AsPlainText -Force) -Enabled 1 
    }
        elseif($usersOrOU -eq "OU"){
            $destinationOU = Read-Host "What is the name of the OU you would like to save the user to "
            New-ADUser -Name "$newUserName" -UserPrincipalName $newUserPrincipalName -GivenName "$1" -Surname "$2" -StreetAddress "$3" -City "$4" -State "$5" -PostalCode "$6" -Company "$7" -Division "$8" -Path "OU=$destinationOU, DC=Adatum, DC=COM" -AccountPassword (ConvertTo-SecureString Password01 -AsPlainText -Force) -Enabled 1
    }
        Get-ADUser -Filter "Name -like '$newUserName'" -properties Name, SAMAccountName, UserPrincipalName, GivenName, Surname, City, State, PostalCode, Company, Division
        pause
    }
    if ($choice -eq "J"){
        $chosenCSV = Read-Host "What is the file name for the csv "
        $CSVusers = Import-csv $env:USERPROFILE\$chosenCSV
        $CSVuserPassword = Read-Host "What is the password you would like them to have "
        foreach ($CSVuser in $CSVusers){
            $CSVName = $CSVuser.Name
            $CSVSamAccountName = $CSVuser.SamAccountName
            $CSVUserPrincipalName = $CSVuser.UserPrincipalName
            $CSVGivenName = $CSVuser.GivenName
            $CSVSurname = $CSVuser.Surname
            $CSVAddress = $CSVuser.Address
            $CSVcity = $CSVuser.city
            $CSVstate = $CSVuser.state
            $CSVPostalCode = $CSVuser.PostalCode
            $CSVDepartment = $CSVuser.Department
            $CSVcompany = $CSVuser.company
            New-ADUser -Name $CSVName -SamAccountName $CSVSamAccountName -UserPrincipalName $CSVUserPrincipalName -GivenName $CSVGivenName -Surname $CSVSurname -StreetAddress $CSVAddress -city $CSVcity -state $CSVcity -PostalCode $CSVPostalCode -Department $CSVDepartment -company $CSVcompany -Path "CN=Users, DC=Adatum, DC=COM" -AccountPassword (ConvertTo-SecureString $CSVuserPassword -AsPlainText -Force) -Enabled 1
        }
        Get-ADUser -Filter * -Properties Name,SamAccountName,UserPrincipalName,GivenName,Surname,StreetAddress,city,state,PostalCode,Department,company
        pause
    }

    if ($choice -eq "K"){
        $chosengrouptomoveto = Read-Host "What is the name of the group you would like to move a user to "
        $chosenusertomove = Read-Host "What is the name of the user you would like to move "
        Add-ADGroupMember "$chosengrouptomoveto" -Members $chosenusertomove
        Get-ADGroupmember -Identity "$chosengrouptomoveto" | Format-Table -Property SamAccountName, DistinguishedName
        pause
    }

    if ($choice -eq "L"){
        $removegroupchoice = Read-Host "What is the name of the group you would like to remove a member from "
        Get-ADGroupMember -Identity "$removegroupchoice" | Format-Table -Property SamAccountName, DistinguishedName
        $choiceLchoice = Read-Host "Should one of these users get removed "
        if ($choiceLchoice -eq "yes"){
            $choiceLuser = Read-Host "What is the name of the user you would like to remove "
            Remove-ADGroupMember -Identity "$removegroupchoice" -Member "$choiceLuser"
            Get-ADGroupmember -Identity "$removegroupchoice" | Format-Table -Property SamAccountName, DistinguishedName
        }
        pause

    }

    if ($choice -eq "M"){
        $removegroupM = Read-Host "What is the name of the group you would like to delete "
        Remove-ADGroup -Identity $removegroupM
        Get-ADGroup -Filter * | Format-Table -Property Name, GroupScope, GroupCategory
        pause
    }

    if ($choice -eq "N"){
        $removeuserN = Read-Host "What is the name of the user you would like to delete "
        Remove-ADUser -Identity $removeuserN
        Get-ADUser -Filter * | Format-Table -Property Name, DistinguishedName
        pause
    }
    else{$answer = 'Y'}
} until ($answer -eq 'Y')