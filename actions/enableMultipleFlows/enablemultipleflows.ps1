
param($flowid,$pass,$user,$envName)

Install-Module -Name Microsoft.PowerApps.Administration.PowerShell -Force
Install-Module -Name Microsoft.PowerApps.PowerShell -AllowClobber -Force

$ErrorActionPreference = "Stop"

Write-Verbose 'Entering powerautomateenablemultipleflows.ps1'

#Login to PowerApps
$powerappspw =ConvertTo-SecureString $pass -AsPlainText -Force
Add-PowerAppsAccount -Username $user -Password $powerappspw

#Return PowerAutomate Flows then iterate over
#Get-Flows
#*PPCCTEST*
$flows=Get-AdminFlow *$flowid* -EnvironmentName $envName
#ForEach-Object (Get-Flow) {Enable-Flow}
foreach($flow in $flows)
{
    write-host -ForegroundColor Green "Flow Name: " $flow.FlowName " Display Name: " $flow.DisplayName " Created Time: " $flow.CreatedTime
    Enable-Flow -FlowName $flow.FlowName -EnvironmentName $envName
}

Write-Verbose 'Leaving powerautomateenablemultipleflows.ps1'