# Staging Northern Europe (3) Enviroment Variables
subnet_prefix = ""
workload      = "APP5373"
appid         = "APP5373"
vmEnv         = "P"
location      = "northeurope"
region        = "NEU"
shared_resource_group = "RG-JUPITER-SHARED-P-NEU01"

# Networking
subnet_count = 0
nsr_count    = 0

# Virtual Machines
vm_count     = 0
platform_fault_domain_count = 2

# IoT Hub
iot_hub_name = "iothapp5373pneu01"
ioth_sku = "S1"
ioth_capacity = "1"

# Azure Container Registry
acrSku = "Basic"
acr_name = "crjupitersharedpneu01"
acr_count = "1"

#Event Hub
eventHubSku = "Standard"