# Add all components in one solution to another solution


param ([string]$psSourceSolutionName,[string]$psTargetSolutionName,[string]$psTargetCRMurl,[string]$psCRMusername,
[string]$psCRMpassword,[string]$psClientId,[string]$psClientSecret,[string]$psAuthType)

Install-Module -Name Microsoft.Xrm.Data.PowerShell -AllowClobber -Force 

Write-Host 'Creating connection to CE'

$connectionString = ""

if ($psAuthType -eq 'OAuth') {
    $connectionString = "AuthType=OAuth;Username=$psCRMusername;Password='$psCRMpassword';Url=$psTargetCRMurl;AppId=51f81489-12ee-4a9e-aaae-a2591f45987d;RedirectUri=app://58145B91-0C36-4500-8554-080854F2AC97;LoginPrompt=Never"
}

if ($psAuthType -eq 'Office365') {
    $connectionString = "AuthType = Office365;Username = $psCRMusername;Password = $psCRMpassword;Url = $psTargetCRMurl"    
}

if ($psAuthType -eq 'ClientSecret') {
    $connectionString = "AuthType=ClientSecret;ClientId=$psClientId;ClientSecret=$psClientSecret;Url=$psTargetCRMurl" 
}

# Retrieve the GUID of the source solution so that the GUID can be used to filter solutioncomponent records
$stagingConn = Get-CrmConnection -ConnectionString $connectionString
$sourceSolutionEC = Get-CrmRecords -conn $stagingConn -EntityLogicalName solution -Fields * -FilterAttribute uniquename -FilterOperator eq -FilterValue $psSourceSolutionName
if($sourceSolutionEC.Count -gt 1){
    throw 'More than one source solution found!'
  }
  elseif($sourceSolutionEC.Count -eq 0){
    throw 'No Solutions Found!'
}


# Get the solution components
$sourceSolution = $sourceSolutionEC.CrmRecords[0]
$sourceSolutionComponents = Get-CrmRecords -conn $stagingConn -EntityLogicalName solutioncomponent -FilterAttribute solutionid -FilterOperator eq -FilterValue $sourceSolution.solutionid.Guid -Fields *

Write-Host 'Count of components found:' $sourceSolutionComponents.CrmRecords.Count

foreach($solutionComponent in $sourceSolutionComponents.CrmRecords)
{
    Write-Host 'Adding component type: '$solutionComponent.componenttype_Property.Value.Value with ID: $solutionComponent.objectid.Guid

    #Add the component to the target solution
    $addComponentRequest = New-Object Microsoft.Crm.Sdk.Messages.AddSolutionComponentRequest
    $addComponentRequest.ComponentType = $solutionComponent.componenttype_Property.Value.Value
    $addComponentRequest.ComponentId = $solutionComponent.objectid.Guid
    $addComponentRequest.SolutionUniqueName = $psTargetSolutionName

    $addComponentResponse = $stagingConn.ExecuteCrmOrganizationRequest($addComponentRequest)
    if($stagingConn.LastCrmException -ne "") {
      Write-Host $conn.LastCrmException 
    }
}

Write-Host 'Finished moving solution components'