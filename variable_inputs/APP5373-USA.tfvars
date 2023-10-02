# Staging USA (3) Enviroment Variables
subnet_prefix = ""
workload      = "APP5373"
appid         = "APP5373"
vmEnv         = "P"
location      = "centralus"
region        = "CUS"
shared_resource_group = "RG-JUPITER-SHARED-P-CUS01"

# Networking
subnet_count = 0
nsr_count    = 0
vm_count     = 0

# IoT Hub
iot_hub_name = "iothapp5373pcus01"
ioth_sku = "S1"
ioth_capacity = "1"

# Azure Container Registry
acrSku = "Basic"
acr_name = "crjupitersharedpcus01"

#Event Hub
eventHubSku = "Standard"