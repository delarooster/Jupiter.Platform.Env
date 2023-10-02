$neuAcrUser = 'crjupitersharednneu01'

$usaAcrUser = 'crjupiterapp5768ncus01'

az acr login --name $usaAcrUser
az acr login --name $neuAcrUser

# from old ACR
$repos = az acr repository list --name $usaAcrUser | ConvertFrom-Json

foreach ($repo in $repos) {
    $tags = az acr repository show-tags --name $usaAcrUser --repository $repo | ConvertFrom-Json

    foreach ($tag in $tags) {
        az acr import `
            -g RG-JUPITER-SHARED-N-NEU01 `
            --name $neuAcrUser `
            --force `
            --source "$($usaAcrUser).azurecr.io/$($repo):$($tag)" `
            --no-wait
    }
}