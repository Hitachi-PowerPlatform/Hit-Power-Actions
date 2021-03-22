# Remove the active customization layer of a workflow (Cloud Flow)

param ([string]$psTenantId,[string]$psClientId,[string]$psClientSecret,[string]$psEnvironmentUrl,[string]$psFilter)
#$psTenantId,$psClientId,$psClientSecret,$psEnvironmentUrl,$psFilter
#Get Parameters

$psVersion = "9.0"
$psSolutionComponentName = "Workflow" #defines the component type


write-host -ForegroundColor Green "Tenant ID" $psTenantId
write-host -ForegroundColor Green "psClientId" $psClientId
write-host -ForegroundColor Green "psClientSecret" $psClientSecret
write-host -ForegroundColor Green "psEnvironmentUrl" $psEnvironmentUrl
write-host -ForegroundColor Green "psFilter" $psFilter


#Request to generate token
$Params = @{
    "URI"     = "https://login.microsoftonline.com/$psTenantId/oauth2/token"
    "Body"    = "client_id=$psClientId&client_secret=$psClientSecret&resource=$psEnvironmentUrl&grant_type=client_credentials"
    "Method"  = 'POST'
    "Headers" = @{
    "Content-Type" = 'application/x-www-form-urlencoded'
    }
   }
   
$psResult = Invoke-RestMethod @Params

#Token retrieval
$psToken = $psResult.access_token


#Filter request variables definition
$filter = '$filter'
$filterWebReqest = "workflows?$filter=contains(name, '$psFilter')"
$webAPIURLFilter = $psEnvironmentUrl+"/api/data/v"+$psVersion+"/"+ $filterWebReqest

Write-Output $webAPIURLFilter

$filterResult = Invoke-RestMethod -Uri $webAPIURLFilter -Method Get -Headers @{authorization = "Bearer " + $psToken}

#For each of the flows that match the criteria the respective workflowid will be retrieved and the layer removed
foreach($flow in $filterResult.value)
{
    write-host -ForegroundColor Green "Flow Name: " $flow.'name' " Workflowid: " $flow.'workflowid'

    $psComponentID = $flow.'workflowid'

    Write-Output $psComponentID

    #Remove layer request variable definitions
    $request = "RemoveActiveCustomizations(ComponentId=("+$psComponentID+"),SolutionComponentName="+"'"+$psSolutionComponentName+"')"
    $webAPIURL = $psEnvironmentUrl+"/api/data/v"+$psVersion+"/"+ $request
    
    Write-Output $webAPIURL

    Invoke-RestMethod -Uri $webAPIURL -Method Get -Headers @{authorization = "Bearer " + $psToken}
}
