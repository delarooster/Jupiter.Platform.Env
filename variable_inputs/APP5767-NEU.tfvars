# Test Northern Europe (2) Environment Variables
subnet_prefix = ""
workload      = "APP5767"
appid         = "APP5767"
vmEnv         = "N"
location      = "northeurope"
region        = "NEU"
shared_resource_group = "RG-JUPITER-SHARED-N-NEU01"

# Networking
subnet_count = 0
nsr_count    = 0

# Virtual Machines
vm_count     = 0
platform_fault_domain_count = 2

# IoT Hub
iot_hub_name = "iothapp5767nneu01"
ioth_sku = "S1"
ioth_capacity = "1"
iothub_qa_auth_rule_count = 1

# Azure Container Registry
acrSku = "Basic"
acr_name = "crjupitersharednneu01"
acr_count = "1"

#Event Hub
eventHubSku = "Standard"
load_test_auth_rule_count = 1