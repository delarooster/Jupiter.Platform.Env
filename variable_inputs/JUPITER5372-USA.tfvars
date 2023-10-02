# Prod USA (4) Enviroment Variables
subnet_prefix = "10.236.33.192/27"
workload      = "Jupiter5372"
appid         = "Jupiter5372"
vmEnv         = "P"
location      = "centralus"

# Networking
subnet_count = 1
nsr_count    = 1
vm_count     = 1   

# IoT Central
iot_central_name = "iotcapp5372pcus01"
iotcDisplayName  = "Callisto USA [Prod]"
iotcSku          = "ST1"

# Azure Container Registry
acrSku = "Basic"
acr_name = "crjupiterapp5372pcus01"

#Event Hub
eventHubSku = "Standard"

#Linux VM
VM_01_OSMachineType_input                   = "Linux"
VM_01_virtualMachineSize                    = "Standard_F72s_v2"
VM_01_naming_index                          = "1"
VM_01_countInt                              = "1"
VM_01_role                                  = ""
VM_01_enable_accelerated_networking         = "true"
## If using Linux Server
VM_01_LinuxStorageImageReferencePublisher   = "Canonical"
VM_01_LinuxStorageImageReferenceOffer       = "UbuntuServer"
VM_01_LinuxStorageImageReferenceSKU         = "20.04-lts"