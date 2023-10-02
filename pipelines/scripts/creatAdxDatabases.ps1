# az kusto database create `
#     --cluster-name dvnasa01adx `
#     --database-name test01 `
#     --resource-group rg-callisto-shared-dv `
#     --subscription cb70135b-a87f-47c4-adc2-9e172bc22f88 `
#     --read-write-database `
#     location="eastus" `
#     soft-delete-period="P365D" `
#     hot-cache-period="P31D"

# TODO Get Event Hub Id
$eventHubId = (az eventhubs eventhub show --name callisto-telemetry --namespace-name DvNasausaehns --resource-group rg-hoth-usa-dv | ConvertFrom-Json).id


az kusto data-connection event-hub create `
    --cluster-name dvnasa01adx `
    --data-connection-name test01-telemetry `
    --database-name test01 `
    --resource-group rg-callisto-shared-dv `
    --subscription cb70135b-a87f-47c4-adc2-9e172bc22f88 `
    --consumer-group adx-connectivity `
    --event-hub-resource-id $eventHubId

