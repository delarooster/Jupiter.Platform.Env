module "device_provisioning_service" {
    source                    = "./terraform_naming_module"
    resource_type_input       = "device_provisioning_service"
    business_unit_input       =  var.business_unit 
    workload                  =  var.workload 
    environment_input         =  var.environment 
    location_descriptor_input =  var.location 
}

resource "azurerm_iothub_dps" "dps" {
  name                = "DPS-JUPITER-SHARED-${var.vmEnv}-${var.region}01"
  resource_group_name = var.shared_resource_group
  location            = var.location
  sku {
    name        = var.dps_sku
    capacity    = var.dps_capacity
  }
  lifecycle {
    ignore_changes = [
      linked_hub
    ]
  }
}