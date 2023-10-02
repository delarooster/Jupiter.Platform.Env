output "dpsName" {
    value = "DPS-JUPITER-SHARED-${var.vmEnv}-${var.region}01"
}

output "shared_resourceGroup" {
    value = var.shared_resource_group
}
output "iotHubName" {
    value = azurerm_iothub.ioth.name
}

output "tier_resourceGroup" {
    value = module.app_rg.concatenated_name
}

output "deploymentRegion" {
    value = var.region
}

output "acrName" {
  value = var.acr_name
}

# output "adxDatabaseName" {
#     value = azurerm_kusto_database.adx_callisto_db.name
# }

# output "adxConnectionString" {
#     value = azurerm_kusto_database.adx_callisto_db.connection_string
# }