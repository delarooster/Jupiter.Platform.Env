param(
    [string]$dps = 'SharedHothusaNDps',
    [string]$shared_resourceGroup = 'rg-hoth-shared-n',
    [string]$subscription = 'cb70135b-a87f-47c4-adc2-9e172bc22f88',
    [string]$env
)
$environmentType = switch ($env) {
    'Sd' {"NonProd"}
    'Dv' {"NonProd"}
    'Ts' {"NonProd"}
    'Sg' {"Prod"}
    'Pd' {"Prod"}
}
$certName = "$($environmentType)-NASA_Corporation_Empower_IoT_Issuing_CA.pem"
$certificateName = "$($environmentType)-Issuing_CA"
$createCertificate = $true

Write-Host "Setting working subscription -> $subscription"
az account set -s $subscription

$certificates = az iot dps certificate list `
                    --dps-name $($dps) `
                    --resource-group $($shared_resourceGroup) `
                    --subscription $subscription | ConvertFrom-Json
foreach($certificate in $certificates.value) {
    if($certificate.name -eq $certificateName) {
        Write-Warning "$certificateName certificate already exists, skipping creation"
        $createCertificate = $false
        break
    }

}

if($createCertificate) {
    az iot dps certificate create `
        --certificate-name $certificateName `
        --path "pipelines/scripts/$($certName)" `
        --verified true `
        --dps-name $($dps) `
        --resource-group $($shared_resourceGroup) `
        --subscription $subscription
}
