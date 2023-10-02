resource "azurerm_storage_account" "fa_sa" {
  name                     = lower("sajupitershared${var.vmEnv}${var.region}01")
  resource_group_name      = var.shared_resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  enable_https_traffic_only = true
}

resource "azurerm_service_plan" "fa_asp" {
  name                = "ASP-JUPITER-SHARED-${var.vmEnv}-${var.region}01"
  location            = var.location
  resource_group_name = var.shared_resource_group
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "fa" {
  name                       = "FA-JUPITER-SHARED-${var.vmEnv}-${var.region}01"
  location                   = var.location
  resource_group_name        = var.shared_resource_group
  service_plan_id = azurerm_service_plan.fa_asp.id
  storage_account_name       = azurerm_storage_account.fa_sa.name
  storage_account_access_key = azurerm_storage_account.fa_sa.primary_access_key
  site_config {}
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"            = azurerm_application_insights.app_insights.instrumentation_key
    "WEBSITE_CONTENTSHARE"                      = azurerm_storage_account.fa_sa.name
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING"  = azurerm_storage_account.fa_sa.primary_connection_string
  }
  lifecycle {
    ignore_changes = [
      app_settings["TableStorageConnectionString"],
      app_settings["DefaultEnvironment"],
      app_settings["NamingConventionType"],
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ] 
  }
}

resource "azurerm_application_insights" "app_insights" {
  name                       = "AI-JUPITER-SHARED-${var.vmEnv}-${var.region}01"
  location                   = var.location
  resource_group_name        = var.shared_resource_group
  application_type           = "web"
}