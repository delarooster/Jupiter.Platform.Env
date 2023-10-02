param(
    [string]$dps = 'SharedHothusaNDps',
    [string]$iot_hub = 'dvhothusaioth',
    [string]$dps_resourceGroup = 'rg-hoth-shared-n',
    [string]$iothub_resourceGroup = 'rg-hoth-usa-dv',
    [string]$subscription
)

az account set -s $subscription

$dps_link = az iot dps linked-hub list --dps-name $($dps) --resource-group $($dps_resourceGroup) | ConvertFrom-Json
$link_exists = $False
foreach($hub in $dps_link.name) {
    if($hub -match $iot_hub) {
        $link_exists = $True
        Write-Warning "Connection link for $iot_hub already exists."
        Write-Warning "Will attempt DPS link update for $iot_hub with $dps."
        break
    }
}

Write-Host "##[command]Retrieving connection string for $($iot_hub)"
$iot_connection_string = az iot hub connection-string show --hub-name $($iot_hub) --resource-group $($iothub_resourceGroup) | ConvertFrom-Json

if(!$link_exists) {
    Write-Host "##[command]Creating Dps Link from $($dps) to $($iot_hub)"
    az iot dps linked-hub create `
        --dps-name $($dps) `
        --connection-string $($iot_connection_string.connectionString) `
        -g $($dps_resourceGroup) `
        --apply-allocation-policy true
}
else {
    Write-Warning "##[command]Updating Dps Link from $($dps) to $($iot_hub)"
    az iot dps linked-hub update `
        --dps-name $($dps) `
        --linked-hub $($iot_hub) `
        -g $($dps_resourceGroup) `
        --apply-allocation-policy true
}