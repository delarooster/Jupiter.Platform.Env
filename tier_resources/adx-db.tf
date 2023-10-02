resource "azurerm_kusto_database" "adx_callisto_db" {
  name                = lower("${var.region}${var.vmEnv}${var.appid}callisto")
  resource_group_name = var.shared_resource_group
  cluster_name        = local.adxCluster
  location            = var.location
}

data "azurerm_storage_account" "fa_sa" {
  name = lower("sajupitershared${var.vmEnv}${var.region}01")
  resource_group_name      = var.shared_resource_group
}

# resource "azurerm_kusto_script" "setup_Connectivity" {
#   name                               = "setup_Connectivity"
#   database_id                        = azurerm_kusto_database.adx_callisto_db.id
#   script_content = <<EOF
#     .create-merge table Connectivity (
#       EnqueuedTime: datetime,
#       CorrelationID: string,
#       HubName: string,
#       OperationType: string,
#       DeviceID: string,
#       ModuleID: string
#     )
#     EOF
#   continue_on_errors_enabled         = true
#   force_an_update_when_value_changed = "first"
# }

# resource "azurerm_kusto_script" "setup_Telemetry" {
#   name                               = "setup_Telemetry"
#   database_id                        = azurerm_kusto_database.adx_callisto_db.id
#   script_content = <<EOF
#     .create-merge table Telemetry (
#         CreationTime: datetime,
#         EnqueuedTime: datetime,
#         SequenceNumber: string,
#         DeviceID: string,
#         Alarm: dynamic,
#         Circuit: dynamic,
#         Mode: dynamic,
#         AcMeter: dynamic,
#         DcMeter: dynamic,
#         Gnss: dynamic,
#         Generator: dynamic,
#         Hvac: dynamic,
#         MarineEngine: dynamic,
#         InverterCharger: dynamic,
#         Tank: dynamic,
#         Hub: dynamic
#     )
#     EOF
#   continue_on_errors_enabled         = true
#   force_an_update_when_value_changed = "first"
# }

resource "azurerm_kusto_eventhub_data_connection" "dc-telemetry" {
  name                = lower("${var.region}-${var.appid}-adx-telemetry")
  resource_group_name = var.shared_resource_group
  location            = var.location
  cluster_name        = local.adxCluster
  database_name       = azurerm_kusto_database.adx_callisto_db.name

  eventhub_id    = azurerm_eventhub.callisto-enriched-telemetry.id
  consumer_group = azurerm_eventhub_consumer_group.adxEnrichedTelemetryConsumerGroup.name

  table_name        = "Telemetry"
  mapping_rule_name = "TelemetryMapping"
  data_format       = "JSON"
  # depends_on = [
  #   azurerm_kusto_script.setup_Telemetry
  # ]
}
resource "azurerm_kusto_eventhub_data_connection" "dc-twin-changes" {
  name                = lower("${var.region}-${var.appid}-adx-twin-changes")
  resource_group_name = var.shared_resource_group
  location            = var.location
  cluster_name        = local.adxCluster
  database_name       = azurerm_kusto_database.adx_callisto_db.name

  eventhub_id    = azurerm_eventhub.callisto-twin-changes.id
  consumer_group = azurerm_eventhub_consumer_group.adxTwinChangesConsumerGroup.name
}
resource "azurerm_kusto_eventhub_data_connection" "dc-connectivity" {
  name                = lower("${var.region}-${var.appid}-adx-enriched-connectivity")
  resource_group_name = var.shared_resource_group
  location            = var.location
  cluster_name        = local.adxCluster
  database_name       = azurerm_kusto_database.adx_callisto_db.name

  eventhub_id    = azurerm_eventhub.callisto-enriched-connectivity.id
  consumer_group = azurerm_eventhub_consumer_group.adxEnrichedConnectivityConsumerGroup.name

  table_name        = "Connectivity"
  mapping_rule_name = "ConnectivityMapping"
  data_format       = "JSON"
}
resource "azurerm_kusto_database_principal_assignment" "crooks_databaseAdmin" {
  name = "Matt Crooks"
  resource_group_name = var.shared_resource_group
  cluster_name        = local.adxCluster
  database_name       = azurerm_kusto_database.adx_callisto_db.name
  tenant_id           = var.azure_tenant_id
  principal_id        = var.mcObjectId
role                  = "Admin"
  principal_type      = "User"
}
resource "azurerm_kusto_database_principal_assignment" "delarosa_databaseAdmin" {
  name                = "Austin DeLaRosa"
  resource_group_name = var.shared_resource_group
  cluster_name        = local.adxCluster
  database_name       = azurerm_kusto_database.adx_callisto_db.name
  tenant_id           = var.azure_tenant_id
  principal_id        = var.atdObjectId
  role                = "Admin"
  principal_type      = "User"
}
resource "azurerm_kusto_database_principal_assignment" "covington_databaseAdmin" {
  name                = "Doak Covington"
  resource_group_name = var.shared_resource_group
  cluster_name        = local.adxCluster
  database_name       = azurerm_kusto_database.adx_callisto_db.name
  tenant_id           = var.azure_tenant_id
  principal_id        = var.dwcObjectId
  role                = "Admin"
  principal_type      = "User"
}