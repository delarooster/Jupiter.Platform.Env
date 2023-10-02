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
  minimum_tls_version = 1.2
}


resource "azurerm_eventhub_namespace_authorization_rule" "empowerAuthRules" {
  name                = "empowerListen"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  resource_group_name = module.app_rg.concatenated_name 

  listen = true
  send   = false
  manage = false
}
resource "azurerm_eventhub_namespace_authorization_rule" "loadTestRules" {
  name                = "load-test-send"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  resource_group_name = module.app_rg.concatenated_name
  count               = var.load_test_auth_rule_count

  listen = false
  send   = true
  manage = false
}

//  Callisto Twin Changes event hub
resource "azurerm_eventhub" "callisto-twin-changes" {
  name                = "callisto-twin-changes"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  resource_group_name = module.app_rg.concatenated_name 
  partition_count     = var.callistoPartitions
  message_retention   = 1
}
// Auth rules
resource "azurerm_eventhub_authorization_rule" "empowerTwinChangesSend" {
  name                = "empower-service-twin-changes-send"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-twin-changes.name
  resource_group_name = module.app_rg.concatenated_name 
  listen              = false
  send                = true
  manage              = false
}
resource "azurerm_eventhub_authorization_rule" "empowerTwinChangesListen" {
  name                = "empower-service-twin-changes-listen"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-twin-changes.name
  resource_group_name = module.app_rg.concatenated_name 
  listen              = true
  send                = false
  manage              = false
}
// Consumer Groups
resource "azurerm_eventhub_consumer_group" "empowerTwinChangesConsumerGroup" {
  name                = "empower-service-iot-twin-changes"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-twin-changes.name
  resource_group_name = module.app_rg.concatenated_name
}

resource "azurerm_eventhub_consumer_group" "adxTwinChangesConsumerGroup" {
  name                = "adx-twin-changes"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-twin-changes.name
  resource_group_name = module.app_rg.concatenated_name
}

// Callisto Telemetry event hub
resource "azurerm_eventhub" "callisto-telemetry" {
  name                = "callisto-telemetry"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  resource_group_name = module.app_rg.concatenated_name 
  partition_count     = var.callistoPartitions
  message_retention   = 1
}
// Auth rules
resource "azurerm_eventhub_authorization_rule" "empowerTelemetrySend" {
  name                = "empower-service-telemetry-send"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-telemetry.name
  resource_group_name = module.app_rg.concatenated_name 
  listen              = false
  send                = true
  manage              = false
}
resource "azurerm_eventhub_authorization_rule" "empowerTelemetryListen" {
  name                = "empower-service-telemetry-listen"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-telemetry.name
  resource_group_name = module.app_rg.concatenated_name 
  listen              = true
  send                = false
  manage              = false
}
// Consumer Groups
resource "azurerm_eventhub_consumer_group" "empowerTelemetryConsumerGroup" {
  name                = "empower-service-iot-telemetry"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-telemetry.name
  resource_group_name = module.app_rg.concatenated_name
}

resource "azurerm_eventhub_consumer_group" "adxTelemetryConsumerGroup" {
  name                = "adx-telemetry"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-telemetry.name
  resource_group_name = module.app_rg.concatenated_name
}

// Callisto Enriched Telemetry event hub
resource "azurerm_eventhub" "callisto-enriched-telemetry" {
  name                = "callisto-enriched-telemetry"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  resource_group_name = module.app_rg.concatenated_name 
  partition_count     = var.callistoPartitions
  message_retention   = 1
}
// Auth rules
resource "azurerm_eventhub_authorization_rule" "empowerEnrichedTelemetrySend" {
  name                = "empower-service-enriched-telemetry-send"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-enriched-telemetry.name
  resource_group_name = module.app_rg.concatenated_name 
  listen              = false
  send                = true
  manage              = false
}
resource "azurerm_eventhub_authorization_rule" "empowerEnrichedTelemetryListen" {
  name                = "empower-service-enriched-telemetry-listen"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-enriched-telemetry.name
  resource_group_name = module.app_rg.concatenated_name 
  listen              = true
  send                = false
  manage              = false
}
// Consumer Groups
resource "azurerm_eventhub_consumer_group" "empowerEnrichedTelemetryConsumerGroup" {
  name                = "empower-service-iot-enriched-telemetry"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-enriched-telemetry.name
  resource_group_name = module.app_rg.concatenated_name
}

resource "azurerm_eventhub_consumer_group" "adxEnrichedTelemetryConsumerGroup" {
  name                = "adx-enriched-telemetry"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-enriched-telemetry.name
  resource_group_name = module.app_rg.concatenated_name
}
// Callisto Enriched-connectivity event hub
resource "azurerm_eventhub" "callisto-enriched-connectivity" {
  name                = "callisto-enriched-connectivity"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  resource_group_name = module.app_rg.concatenated_name 
  partition_count     = var.callistoPartitions
  message_retention   = 1
}
// Auth rules
resource "azurerm_eventhub_authorization_rule" "empowerEnrichedConnectivitySend" {
  name                = "empower-service-enriched-connectivity-send"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-enriched-connectivity.name
  resource_group_name = module.app_rg.concatenated_name 
  listen              = false
  send                = true
  manage              = false
}
resource "azurerm_eventhub_authorization_rule" "empowerEnrichedConnectivityListen" {
  name                = "empower-service-enriched-connectivity-listen"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-enriched-connectivity.name
  resource_group_name = module.app_rg.concatenated_name 
  listen              = true
  send                = false
  manage              = false
}
// Consumer Groups
resource "azurerm_eventhub_consumer_group" "empowerEnrichedConnectivityConsumerGroup" {
  name                = "empower-service-iot-enriched-connectivity"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-enriched-connectivity.name
  resource_group_name = module.app_rg.concatenated_name
}

resource "azurerm_eventhub_consumer_group" "adxEnrichedConnectivityConsumerGroup" {
  name                = "adx-enriched-connectivity"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-enriched-connectivity.name
  resource_group_name = module.app_rg.concatenated_name
}

// Callisto Connectivity event hub
resource "azurerm_eventhub" "callisto-connectivity" {
  name                = "callisto-connectivity"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  resource_group_name = module.app_rg.concatenated_name 
  partition_count     = var.callistoPartitions
  message_retention   = 1
}
// Auth rules
resource "azurerm_eventhub_authorization_rule" "empowerConnectivitySend" {
  name                = "empower-service-connectivity-send"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-connectivity.name
  resource_group_name = module.app_rg.concatenated_name 
  listen              = false
  send                = true
  manage              = false
}
resource "azurerm_eventhub_authorization_rule" "empowerConnectivityListen" {
  name                = "empower-service-connectivity-listen"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-connectivity.name
  resource_group_name = module.app_rg.concatenated_name 
  listen              = true
  send                = false
  manage              = false
}
// Consumer Groups
resource "azurerm_eventhub_consumer_group" "empowerConnectivityConsumerGroup" {
  name                = "empower-service-iot-connectivity"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-connectivity.name
  resource_group_name = module.app_rg.concatenated_name
}

resource "azurerm_eventhub_consumer_group" "adxConnectivityConsumerGroup" {
  name                = "adx-connectivity"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.callisto-connectivity.name
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
  name                = "empower"
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.nauticon.name
  resource_group_name = module.app_rg.concatenated_name 
}