# Generate name for IOT Central
# module "app_iotcentral" {
#     source                    = "./terraform_naming_module"
#     resource_type_input       = "iot_central"
#     business_unit_input       =  var.business_unit 
#     workload                  =  var.workload 
#     environment_input         =  var.environment 
#     location_descriptor_input =  var.location 
# }

#Deploy IOT Central
resource "azurerm_iotcentral_application" "iotc" {
  name                = var.iot_central_name
  resource_group_name = module.app_rg.concatenated_name 
  location            = var.location
  sub_domain          = var.iot_central_name
  display_name        = var.iotcDisplayName
  sku                 = var.iotcSku
}