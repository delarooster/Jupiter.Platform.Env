param(
    [string]$dps = 'SharedHothusaNDps',
    [string]$shared_resourceGroup = 'rg-hoth-shared-n',
    [string]$iot_hub = 'dvhothusaioth',
    [string]$tier_resourceGroup = 'rg-hoth-usa-dv',
    [string]$subscription = 'cb70135b-a87f-47c4-adc2-9e172bc22f88',
    [string]$env = 'Sd',
    [string]$deploymentRegion = 'NEU'
)

az account set -s $subscription

$enrollmentGroups = az iot dps enrollment-group list `
                        --dps-name $($dps) `
                        --resource-group $($shared_resourceGroup) `
                        --subscription $subscription | ConvertFrom-Json

$group_exists = $false    
$group_name = switch ($env) {
    'Sd' {"NonProd"}
    'Dv' {"NonProd"}
    'Ts' {"NonProd"}
    'Sg' {"Prod"}
    'Pd' {"Prod"}
}
$certName = "$($group_name)-NASA_Corporation_Empower_IoT_Issuing_CA.pem"

# check whether iot hub has enrollment group within DPS
foreach($group in $enrollmentGroups) {
    if($group.enrollmentGroupId -like "$($group_name)*") {
        Write-Warning "Existing enrollment group for IoT Hub: $($iot_hub) within DPS: $($dps) "
        $group_exists = $true
        #TODO an update to existing link?
    }
}

if(!$group_exists) {
    $fa_function = "AllocateDevice"
    # : Get 'N' for Non-Prod and 'P' for Production
    $isProduction = $group_name.ToCharArray()[0]
    $functionApp_name = "FA-JUPITER-SHARED-$($isProduction)-$($deploymentRegion)01"
    Write-Host "Function app name: $($functionApp_name)"
    $fa_hostName = (az functionapp config hostname list `
                                --webapp-name $($functionApp_name) `
                                --resource-group $($shared_resourceGroup) | ConvertFrom-Json).name

    $fa_key = (az functionapp function keys list `
                --name $($functionApp_name) `
                --resource-group $($shared_resourceGroup) `
                --function-name $($fa_function) | ConvertFrom-Json).default
    $fa_webhook_uri = "https://$($fa_hostName)/api/$($fa_function)?code=$($fa_key)"
    # TODO remove key print out to screen
    Write-Host "Function app hostname: $($fa_webhook_uri)"


    # : 5768 is moniker for `Develop`, 5372 is 'Production'
    # : DPS groups will only target either of the above by default
    $allocated_iot_hub = switch ($group_name) {
        'Non_Prod' {"5768"}
        'Production' {"5372"}
    }
    $targetedIoTHub = "IOT-JUPITER-APP$($allocated_iot_hub)-$($isProduction)-$($deploymentRegion)01"
    
    Write-Host "##[command]Creating new enrollment group: $group_name for $targetedIoTHub"

    az iot dps enrollment-group create `
        --resource-group $($shared_resourceGroup)`
        --dps-name $($dps) `
        --enrollment-id $group_name `
        --allocation-policy custom `
        --webhook-url $($fa_webhook_uri) `
        --api-version 2021-10-01 `
        --edge-enabled true `
        --certificate-path "pipelines/scripts/$($certName)"
}
else {
    Write-Warning "Enrollment group already exists for $($group_name) on $($dps), skipping enrollment creation"
}
