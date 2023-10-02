# Generate name for Container Registry
module "app_container_registry" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "container_registry"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
}


resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.shared_resource_group
  location            = var.location
  sku                 = var.acrSku
  admin_enabled       = false
  count               = var.acr_count
}