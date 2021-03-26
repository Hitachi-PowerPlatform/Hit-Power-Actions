param($environmentID,$user,$pass,$canvasAppID,$role,$filePath)
$ErrorActionPreference = "Stop"

Install-Module -Name Microsoft.PowerApps.Administration.PowerShell -Force
Install-Module -Name Microsoft.PowerApps.PowerShell -AllowClobber -Force
Install-Module -Name AzureAD -AllowClobber -Force

Write-Verbose 'Entering sharecanvasppmultipleusers.ps1'

$roleString = ""
Write-Host "role"

Write-Host $role

if ($role -eq 'canview') {
    $roleString = "CanView"
}

if ($role -eq 'canviewshare') {
    $roleString = "CanViewWithShare"
}
if ($role -eq 'canedit') {
    $roleString = "CanEdit"
}
Write-Host "roleString"
Write-Host $roleString
#Secure the password
$password = ConvertTo-SecureString -String $pass -AsPlainText -Force

#Log in to powerapps
Add-PowerAppsAccount -Username $user -Password $password

#Connect to the Azure Active Directory
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
Connect-AzureAD -Credential $Credential

#Import the file and go through each of the records (email of the users to share the app to)
Import-Csv $filePath | ForEach-Object {
    $shareUser = Get-AzureADUser -ObjectId $($_.EmployeeEmail) #this is the name of the column on the csv file
    $userObjectID = $shareUser.ObjectId
    Set-PowerAppRoleAssignment -AppName $canvasAppID -EnvironmentName $environmentID -RoleName $roleString -PrincipalType User -PrincipalObjectId $userObjectID    
}
    





