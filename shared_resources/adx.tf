resource "azurerm_kusto_cluster" "adx" {
  name                = lower("adxjupitershared${var.vmEnv}${var.region}01")
  location            = var.location
  resource_group_name = var.shared_resource_group
  sku {
    name     = var.adx_cluster_sku
    capacity = var.adx_cluster_capacity
  }
  auto_stop_enabled           = false
  streaming_ingestion_enabled = true
  engine                      = "V3"
}