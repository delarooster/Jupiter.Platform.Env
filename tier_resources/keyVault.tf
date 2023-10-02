# Generate Name for Key vault
module "app_keyvault" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "key_vault"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyVault" {
  name                        = module.app_keyvault.concatenated_name
  location                    = var.location
  resource_group_name         = module.app_rg.concatenated_name 
  tenant_id                   = var.azure_tenant_id 
  soft_delete_retention_days  = 7
  sku_name                    = "standard"

  access_policy {
    tenant_id = var.azure_tenant_id 
    object_id = var.atdObjectId

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
    ]
  }
  access_policy {
    tenant_id = var.azure_tenant_id 
    object_id = var.mcObjectId

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
    ]
  }
  access_policy {
    tenant_id = var.azure_tenant_id 
    object_id = var.dwcObjectId

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
    ]
  }
  access_policy {
    tenant_id = var.azure_tenant_id 
    object_id = var.aksApp2937Sp
    
    secret_permissions = [
      "Get",
    ]
    key_permissions = [
      "Get",
    ]
  }
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
    ]
  }
}

resource "azurerm_key_vault_secret" "iot_hub_conn_string" {
  name          = "IOT-HUB-CONNECTION-STRING"
  value         = azurerm_iothub_shared_access_policy.ioth_read_write.primary_connection_string
  content_type  = "IoT Hub ${var.vmEnv} ${var.region} ${var.appid} connection string"
  key_vault_id  = azurerm_key_vault.keyVault.id
}

resource "azurerm_key_vault_secret" "storage_container" {
  name          = "STORAGE-CONTAINER-NAME-EVH"
  value         = "event-hub-checkpoints"
  content_type  = "Name of container to store event hub checkpoints"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "storage_conn_string" {
  name          = "STORAGE-CONNECTION-STRING"
  value         = module.app_pattern.sa_primary_connection_string
  content_type  = "Connection string for access to blob storage"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_twin_changes_consumer_group" {
  name          = "EVH-CONSUMER-GROUP-EMPOWER-TWIN-CHANGES"
  value         =  azurerm_eventhub_consumer_group.empowerTwinChangesConsumerGroup.name
  content_type  = "Consumer group for Empower IoT Twin Changes service"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_telemetry_consumer_group" {
  name          = "EVH-CONSUMER-GROUP-EMPOWER-TELEMETRY"
  value         =  azurerm_eventhub_consumer_group.empowerTelemetryConsumerGroup.name
  content_type  = "Consumer group for Empower IoT Telemetry service"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_connectivity_consumer_group" {
  name          = "EVH-CONSUMER-GROUP-EMPOWER-CONNECTIVITY"
  value         =  azurerm_eventhub_consumer_group.empowerConnectivityConsumerGroup.name
  content_type  = "Consumer group for Empower IoT Twin Changes service"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_nauticon" {
  name          = "EVH-HUBNAME-NAUTICON"
  value         = "${azurerm_eventhub.nauticon.name}"
  content_type  = "Name of hub for Nautic-On events"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_callisto_twin_changes" {
  name          = "EVH-HUBNAME-EUROPA-TWIN-CHANGES"
  value         =  azurerm_eventhub.callisto-twin-changes.name
  content_type  = "Name of hub for Callisto Twin Changes events"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_callisto_telemetry" {
  name          = "EVH-HUBNAME-EUROPA-TELEMETRY"
  value         =  azurerm_eventhub.callisto-telemetry.name
  content_type  = "Name of hub for Callisto Telemetry events"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_callisto_connectivity" {
  name          = "EVH-HUBNAME-EUROPA-CONNECTIVITY"
  value         =  azurerm_eventhub.callisto-connectivity.name
  content_type  = "Name of hub for Callisto Connectivity events"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_empower_twin_changes_conn_string" {
  name          = "EVH-CONNECTION-STRING-EMPOWER-TWIN-CHANGES-LISTEN"
  value         = azurerm_eventhub_authorization_rule.empowerTwinChangesListen.primary_connection_string
  content_type  = "Connection string for listening to Empower Twin Changes Listen events"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_empower_telemetry_conn_string" {
  name          = "EVH-CONNECTION-STRING-EMPOWER-TELEMETRY-LISTEN"
  value         = azurerm_eventhub_authorization_rule.empowerTelemetryListen.primary_connection_string
  content_type  = "Connection string for listening to Empower Telemetry Listen events"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_empower_connectivity_conn_string" {
  name          = "EVH-CONNECTION-STRING-EMPOWER-CONNECTIVITY-LISTEN"
  value         = azurerm_eventhub_authorization_rule.empowerConnectivityListen.primary_connection_string
  content_type  = "Connection string for listening to Empower Connectivity Listen events"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_nauticon_conn_string" {
  name          = "EVH-CONNECTION-STRING-NAUTICON-SEND"
  value         = azurerm_eventhub_authorization_rule.deviceServiceAuthRules.primary_connection_string
  content_type  = "Connection string for sending Nautic-On events"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "egd_empower_primary_key" {
  name          = "EGD-EMPOWER-PRIMARY-KEY"
  value         = azurerm_eventgrid_domain.eventgrid_domain_empower.primary_access_key
  content_type  = "Primary key for Empower Event Grid Topic"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "egd_empower_secondary_key" {
  name          = "EGD-EMPOWER-SECONDARY-KEY"
  value         = azurerm_eventgrid_domain.eventgrid_domain_empower.secondary_access_key
  content_type  = "Secondary key for Empower Event Grid Topic"
  key_vault_id  = azurerm_key_vault.keyVault.id
}

# TODO Remove after new permissions are enabled
# tl;dr due to TF event chains the above permissions 
# to 'delete' a secret isn't enabled prior to a secret being removed
resource "azurerm_key_vault_secret" "evh_consumer_group" {
  name          = "EVH-CONSUMER-GROUP-EMPOWER"
  value         = "empower"
  content_type  = "Consumer group for Empower service"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_callisto" {
  name          = "EVH-HUBNAME-EUROPA"
  value         = "callisto"
  content_type  = "Name of hub for Callisto events"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_empower_conn_string" {
  name          = "EVH-CONNECTION-STRING-EMPOWER-LISTEN"
  value         = "${azurerm_eventhub_namespace_authorization_rule.empowerAuthRules.primary_connection_string}"
  content_type  = "Connection string for listening to Empower event"
  key_vault_id  = azurerm_key_vault.keyVault.id
}