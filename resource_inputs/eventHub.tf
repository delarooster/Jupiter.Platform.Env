# Generate names for event hubs and namespace
module "app_event_hub_namespace" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "event_hub_namespace"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
}

module "app_event_hub_callisto" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "event_hub"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
    naming_index              = 01
}

module "app_event_hub_nauticon" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "event_hub"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
    naming_index              = 02
}

# Event Hub NameSpace
resource "azurerm_eventhub_namespace" "eventHubNs" {
  name                = module.app_event_hub_namespace.concatenated_name
  location            = var.location
  resource_group_name = module.app_rg.concatenated_name 
  sku                 = var.eventHubSku
  capacity            = 1

  # tags = {
  #   environment = var.env
  # }
}


resource "azurerm_eventhub_namespace_authorization_rule" "ganymedeAuthRules" {
  name                = "ganymedeListen"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  resource_group_name = module.app_rg.concatenated_name 

  listen = true
  send   = false
  manage = false
}

#  Callisto event hub
resource "azurerm_eventhub" "callisto" {
  name                = "callisto"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  resource_group_name = module.app_rg.concatenated_name 
  partition_count     = var.callistoPartitions
  message_retention   = 1
}
resource "azurerm_eventhub_authorization_rule" "iotcAuthRules" {
  name                = "iotcSend"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto.name
  resource_group_name = module.app_rg.concatenated_name 
  listen              = false
  send                = true
  manage              = false
}
resource "azurerm_eventhub_consumer_group" "ganymedeConsumerGroup" {
  name                = "ganymede"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto.name
  resource_group_name = module.app_rg.concatenated_name
}

// Nauticon event hub
resource "azurerm_eventhub" "nauticon" {
  name                = "nauticon"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  resource_group_name = module.app_rg.concatenated_name
  partition_count     = 2
  message_retention   = 1
}
resource "azurerm_eventhub_authorization_rule" "deviceServiceAuthRules" {
  name                = "deviceServiceSend"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.nauticon.name
  resource_group_name = module.app_rg.concatenated_name
  listen              = false
  send                = true
  manage              = false
}
resource "azurerm_eventhub_consumer_group" "nauticonConsumerGroup" {
  name                = "ganymede"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.nauticon.name
  resource_group_name = module.app_rg.concatenated_name 
}