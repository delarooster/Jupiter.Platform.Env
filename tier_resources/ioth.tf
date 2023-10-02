module "iot_hub" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "iot_hub"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
}

resource "azurerm_iothub" "ioth" {
  name                = module.iot_hub.concatenated_name
  resource_group_name = module.app_rg.concatenated_name 
  location            = var.location
  sku                 {
    name      = var.ioth_sku
    capacity  = var.ioth_capacity
  }

  endpoint {
    name = "twin-changes"
    type = "AzureIotHub.EventHub"
    connection_string = azurerm_eventhub_authorization_rule.empowerTwinChangesSend.primary_connection_string
  }
  endpoint {
    name = "telemetry"
    type = "AzureIotHub.EventHub"
    connection_string = azurerm_eventhub_authorization_rule.empowerTelemetrySend.primary_connection_string
  }
  endpoint {
    name = "connectivity"
    type = "AzureIotHub.EventHub"
    connection_string = azurerm_eventhub_authorization_rule.empowerConnectivitySend.primary_connection_string
  }

  route {
    name            = "telemetry"
    source          = "DeviceMessages"
    condition       = "true"
    endpoint_names  = ["telemetry"]
    enabled         = true
  }
  route {
    name            = "twin-changes"
    source          = "TwinChangeEvents"
    condition       = "true"
    endpoint_names  = ["twin-changes"]
    enabled         = true
  }
  route {
    name            = "connectivity"
    source          = "DeviceConnectionStateEvents"
    condition       = "true"
    endpoint_names  = ["connectivity"]
    enabled         = true
  }
}

resource "azurerm_iothub_shared_access_policy" "ioth_read_write" {
  name                = "empower-service"
  resource_group_name = azurerm_iothub.ioth.resource_group_name
  iothub_name         = azurerm_iothub.ioth.name

  registry_read       = true
  registry_write      = true
  service_connect     = true
}
resource "azurerm_iothub_shared_access_policy" "ioth_qa" {
  name                = "empower-qa"
  resource_group_name = azurerm_iothub.ioth.resource_group_name
  iothub_name         = azurerm_iothub.ioth.name
  count               = var.iothub_qa_auth_rule_count

  registry_read       = true
  registry_write      = true
  service_connect     = true
}