cls
$Question = @"
What do you want to do?
    1. Write a contact entry to a file
    2. Display all files last written to after a given date
    3. Read a specified text file

"@
echo $Question
$Answer = Read-Host "Type in either 1, 2, or 3"

If ($Answer -eq "1") {
    'Item 1 chosen'
    $Fullname = Read-Host "Please enter your full name"
    $Number = Read-Host "Please enter your phone number"
    $Email = Read-Host "Please enter your email address"
    $Filename = Read-Host "Please enter what you would like to name this file"
    Add-Content -path C:\Users\borconc\$Filename.txt -Value $Fullname, $Number, $Email, ""
    }
ElseIf ($Answer -eq "2") {
    'Item 2 chosen'
    cd $env:USERPROFILE
    $Earliestdate = Read-Host "Please enter the earliest date that the file can be"
    Get-ChildItem -Verbose | Sort-Object LastWriteTime | Where-Object {$_.LastWriteTime -gt ($Earliestdate)} | format-table -Property Name, LastWriteTime
    }
ElseIf ($Answer -eq "3") {
    'Item 3 chosen'
    $Filename = Read-Host "Please enter the name of the file you would like to read"
    $Truth = Test-Path $Filename
    if ($Truth -eq "True") {
        Get-Content $Filename
    }
    else {
        echo "File not found"
        }
    }
Else {
    'You have entered an invalid response'
    echo $env:COMPUTERNAME
    echo $env:USERNAME
    }