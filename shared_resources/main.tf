#Provider config
provider "azurerm" {
    subscription_id =  var.azure_sub_id 
    client_id       =  var.azure_client_id 
    client_secret   =  var.azure_client_secret 
    tenant_id       =  var.azure_tenant_id 
    partner_id      =  var.cuaGuid
    features{
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
}

#Generate name for app resource groups
module "app_rg" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "resource_group"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
}

#Generate name for app subnet
module "app_sn" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "subnet"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
}

#Generate name for app NSG
module "app_nsg" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "network_security_group"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
}

# Generate name for recovery services vault
module "app_rsv" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "recovery_services_vault"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
}

# Generate name for storage account
module "app_sa" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "storage_account"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
}

#App Insight Naming
module "app_ai" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "application_insights"
    business_unit_input       = var.business_unit
    workload                  = var.workload
    environment_input         = var.environment
    location_descriptor_input = var.location
}

# Shared Resource Group
module "app_pattern" {
    source                = "./terraform_standard_application_module"
    subnet_count          = "0"
    recovery_vault_count  = "0"
    storage_account_count = "0"
    appinsights_count     = "0"
    environment           =  var.environment 
    location              =  var.location 
    division              =  var.business_unit 
    cost_center           =  var.cost_center 
    requestor             =  var.requestor 
    confidentiality_input =  var.confidentiality 
    accessibility_input   =  var.accessibility 
    criticality_input     =  var.criticality 
    appid                 =  var.appid 
    audit_input           =  var.audit 
    expiration_date       =  var.expiration_date 
    virtual_network       =  var.virtual_network 
    virtual_network_rg    =  var.virtual_network_rg 
    subnet_prefix         =  var.subnet_prefix 
    resource_group_name   =  var.shared_resource_group
    subnet_name           =  module.app_sn.concatenated_name 
    nsg_name              =  "NSG-JUPITER-SHARED-${var.vmEnv}-${var.region}01"
    recovery_vault_name   =  module.app_rsv.concatenated_name 
    appinsights_name      =  module.app_ai.concatenated_name
    storage_account_name  =  module.app_sa.lower_name_rand 
    sub_id                =  var.azure_sub_id 
    rt_id                 =  var.rt_id 
}

### If subnet_count = 0 above, comment this section out ####
# module "app_nsr" {
#     source              = "./terraform_nsg_rules_azure_module"
#     resource_group_name =  module.app_pattern.rg_name 
#     nsg_name            =  module.app_pattern.nsg_name 
#     subnet_prefix       =  var.subnet_prefix
#     count               =  var.nsr_count
# }

# module "app_as" {
#     source                    = "./terraform_naming_module"
#     resource_type_input       = "availability_set"
#     business_unit_input       =  var.business_unit 
#     workload                  =  var.workload 
#     environment_input         =  var.environment 
#     location_descriptor_input =  var.location 
#     naming_index              = "01"
# }

# resource "azurerm_availability_set" "application" {
#     name                        =  module.app_as.concatenated_name
#     location                    =  var.location
#     platform_fault_domain_count =  var.platform_fault_domain_count
#     resource_group_name         =  module.app_pattern.rg_name 
#     managed                     = "true"
# }
# Backup Policy
module "app_backup" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "backup_policy"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
    naming_index              = "01"
}
# module "backup_policy" {
#     source                    = "./terraform_backup_policy_module"
#     backup_policy_name        =  module.app_backup.concatenated_name 
#     resource_group_name       =  module.app_pattern.rg_name 
#     recovery_vault_name       =  module.app_pattern.rsv_name 
#     environment               =  var.environment 
# }

