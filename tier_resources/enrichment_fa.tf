resource "azurerm_storage_account" "enrichment_fa_sa" {
  name                     = lower("sajupiter${var.appid}${var.vmEnv}${var.region}01")
  resource_group_name      = module.app_rg.concatenated_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  enable_https_traffic_only = true
}
resource "azurerm_service_plan" "enrichment_fa_asp" {
  name                = "ASP-JUPITER-${var.appid}-${var.vmEnv}-${var.region}01"
  location            = var.location
  resource_group_name = module.app_rg.concatenated_name
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "enrichment_fa" {
  name                       = "FA-JUPITER-${var.appid}-${var.vmEnv}-${var.region}01"
  location                   = var.location
  resource_group_name        = module.app_rg.concatenated_name
  service_plan_id = azurerm_service_plan.enrichment_fa_asp.id
  storage_account_name       = azurerm_storage_account.enrichment_fa_sa.name
  storage_account_access_key = azurerm_storage_account.enrichment_fa_sa.primary_access_key
  site_config {}
  app_settings = {
      "APPINSIGHTS_INSTRUMENTATIONKEY"            = data.azurerm_application_insights.app_insights.instrumentation_key
      "WEBSITE_CONTENTSHARE"                      = azurerm_storage_account.enrichment_fa_sa.name
      "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING"  = azurerm_storage_account.enrichment_fa_sa.primary_connection_string
  }
  lifecycle {
    ignore_changes = [
      app_settings["InputConnectivityEventHubConsumerGroup"],
      app_settings["InputConnectivityEventHubConnectionString"],
      app_settings["OutputConnectivityEventHubConnectionString"],
      app_settings["InputTelemetryEventHubConsumerGroup"],
      app_settings["InputTelemetryEventHubConnectionString"],
      app_settings["OutputTelemetryEventHubConnectionString"],
      app_settings["NamingConventionType"],
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ] 
  }
}

data "azurerm_application_insights" "app_insights" {
  name                       = "AI-JUPITER-SHARED-${var.vmEnv}-${var.region}01"
  resource_group_name        = var.shared_resource_group
}