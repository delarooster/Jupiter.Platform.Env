resource "azurerm_eventgrid_domain" "eventgrid_domain_empower" {
    name                = "EGD-EMPOWER-JUPITER-${var.appid}-${var.vmEnv}-${var.region}01"
    location            = var.location
    resource_group_name = module.app_rg.concatenated_name
    input_schema        = "CloudEventSchemaV1_0"
}

resource "azurerm_eventgrid_domain_topic" "eventgrid_domain_topic_empower" {
    name                = "EGDT-EMPOWER-JUPITER-${var.appid}-${var.vmEnv}-${var.region}01"
    resource_group_name = module.app_rg.concatenated_name 
    domain_name         = azurerm_eventgrid_domain.eventgrid_domain_empower.name
}