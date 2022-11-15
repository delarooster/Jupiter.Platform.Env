param(
    [string]$copyUsersFromIoTC = '5c42fb38-0a40-4753-8399-522ae7d649a0', #USA Sandbox
    [string]$targetIotCentral = '9cb7d6f9-23fa-49fc-a8f6-d8adfad5bf78'
)

$userList = az iot central user list --app-id $copyUsersFromIoTC

$userList = $userList | ConvertFrom-Json

for($i = 0; $i -lt $userList.Count; $i++) 
{
    $user = $userList[$i]
    if($user.email)
    {
        az iot central user create `
            --app-id $targetIotCentral `
            --email $user.email `
            --user-id $user.id `
            --role admin 
    }
}