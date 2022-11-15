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
      "Set"
    ]
  }
  access_policy {
    tenant_id = var.azure_tenant_id 
    object_id = var.mcObjectId

    secret_permissions = [
      "Get",
      "List",
      "Set"
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
    "Set"
    ]
  }
}

resource "azurerm_key_vault_secret" "storage_container" {
  name          = "STORAGE-CONTAINER-NAME-EVH"
  value         = "event-hub-checkpoints"
  content_type  = "Name of container to store event hub checkpoints"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "storage_conn_string" {
  name          = "STORAGE-CONNECTION-STRING"
  value         = "${module.app_pattern.sa_primary_connection_string}"
  content_type  = "Connection string for access to blob storage"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_consumer_group" {
  name          = "EVH-CONSUMER-GROUP-GANYMEDE"
  value         = "ganymede"
  content_type  = "Consumer group for Ganymede service"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_nauticon" {
  name          = "EVH-HUBNAME-NAUTICON"
  value         = "nauticon"
  content_type  = "Name of hub for Nautic-On events"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_callisto" {
  name          = "EVH-HUBNAME-CALLISTO"
  value         = "callisto"
  content_type  = "Name of hub for Callisto events"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_ganymede_conn_string" {
  name          = "EVH-CONNECTION-STRING-GANYMEDE-LISTEN"
  value         = "${azurerm_eventhub_namespace_authorization_rule.ganymedeAuthRules.primary_connection_string}"
  content_type  = "Connection string for listening to Ganymede event"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
resource "azurerm_key_vault_secret" "evh_nauticon_conn_string" {
  name          = "EVH-CONNECTION-STRING-NAUTICON-SEND"
  value         = "${azurerm_eventhub_authorization_rule.deviceServiceAuthRules.primary_connection_string}"
  content_type  = "Connection string for sending Nautic-On events"
  key_vault_id  = azurerm_key_vault.keyVault.id
}
data "azurerm_eventhub_namespace_authorization_rule" "ganymedeAuthRules" {
  name                = "${azurerm_eventhub_namespace_authorization_rule.ganymedeAuthRules.name}"
  resource_group_name = module.app_rg.concatenated_name
  namespace_name      = module.app_event_hub_namespace.concatenated_name
}

data "azurerm_eventhub_authorization_rule" "deviceServiceAuthRules" {
  name                = "${azurerm_eventhub_authorization_rule.deviceServiceAuthRules.name}"
  resource_group_name = module.app_rg.concatenated_name
  namespace_name      = module.app_event_hub_namespace.concatenated_name
  eventhub_name       = azurerm_eventhub.nauticon.name
}