output "eventHubNamespaceName" {
    value = azurerm_eventhub_namespace.eventHubNs.name
}

output "iotCentralName" {
    value = azurerm_iotcentral_application.iotc.name
}

output "keyVaultName" {
    value = azurerm_key_vault.keyVault.name
}