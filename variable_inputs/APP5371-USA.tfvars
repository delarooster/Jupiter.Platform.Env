# Sandbox (0) Enviroment Variables
subnet_prefix = "10.236.90.224/27"
workload      = "APP5371"
appid         = "APP5371"
vmEnv         = "N"
location      = "centralus"
region        = "CUS"
shared_resource_group = "RG-JUPITER-SHARED-N-CUS01"

# Networking
subnet_count = 0
nsr_count    = 0
vm_count     = 0

# IoT Hub
iot_hub_name = "iothapp5371ncus01"
ioth_sku = "S1"
ioth_capacity = "1"
iothub_qa_auth_rule_count = 1

# Azure Container Registry
acrSku = "Basic"
acr_name = "crjupitersharedncus01"

#Event Hub
eventHubSku = "Standard"
callistoPartitions = 2
load_test_auth_rule_count = 1
