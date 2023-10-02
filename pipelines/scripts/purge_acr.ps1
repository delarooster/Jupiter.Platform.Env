param(
    [string]$acr_name = 'DvAcecoAcr',
    [string]$resourceGroup = 'rg-scs-shared',
    [string]$subscription = '936448e6-88de-4ce9-8876-ee784a6e7277',
    [string]$deploymentRegion = 'NEU'
)

az account set -s $subscription

if($deploymentRegion -eq 'NEU') {
  $acr_task = az acr task show -n purgeAcr -r $acr_name
  #$PURGE_CMD="acr purge --filter 'callisto:.*' --ago 90d" 
  $PURGE_CMD="acr purge --ago 90d" 
  if(!$acr_task) {
    Write-Host "##[command]Creating ACR Task"
    az acr task create `
      --registry $acr_name `
      --cmd $PURGE_CMD `
      --name purgeAcr `
      --context /dev/null `
      -g $resourceGroup `
      --subscription $subscription
    
    # Scheduled task to run at weekly at 0800 PDT on mondays 
    Write-Host "##[command]Adding timer to ACR task"
    az acr task timer add `
      --name purgeAcr `
      --registry $acr_name `
      --schedule "0 16 * * 1" `
      --timer-name purgeAcrTimer `
      --enabled True `
      -g $resourceGroup `
      --subscription $subscription
  }
  else {
    Write-Host "##[command]Deleting ACR Task"
    az acr task delete `
      --name purgeAcr `
      --registry $acr_name `
      --yes
    
    Write-Host "##[command]Recreating ACR Task"
    az acr task create `
      --name purgeAcr `
      --cmd $PURGE_CMD `
      --registry $acr_name `
      --context /dev/null `
      -g $resourceGroup `
      --subscription $subscription
    
    Write-Host "##[command]Recreating timer to ACR task"
    az acr task timer add `
      --name purgeAcr `
      --registry $acr_name `
      --schedule "0 16 * * 1" `
      --timer-name purgeAcrTimer `
      --enabled True `
      -g $resourceGroup `
      --subscription $subscription
  }
}
else {
  Write-Warning "ACRs only exist in Northern Europe Shared Resource Groups, skipping creation of task"
}