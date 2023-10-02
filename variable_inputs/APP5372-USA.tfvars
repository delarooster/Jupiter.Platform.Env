# Prod USA (4) Enviroment Variables
subnet_prefix = "10.236.33.192/27"
workload      = "APP5372"
appid         = "APP5372"
vmEnv         = "P"
location      = "centralus"
region        = "CUS"
shared_resource_group = "RG-JUPITER-SHARED-P-CUS01"

# Networking
subnet_count = 1
nsr_count    = 1
vm_count     = 1   

# IoT Hub
iot_hub_name = "iothapp5372pcus01"
ioth_sku = "S1"
ioth_capacity = "1"

# Azure Container Registry
acrSku = "Basic"
acr_name = "crjupitersharedpcus01"

#Event Hub
eventHubSku = "Standard"

#Linux VM
VM_01_OSMachineType_input                   = "Linux"
VM_01_virtualMachineSize                    = "Standard_F72s_v2"
VM_01_naming_index                          = "1"
VM_01_countInt                              = "1"
VM_01_role                                  = ""
VM_01_enable_accelerated_networking         = "true"
VM_01_storageOSDiskSize                     = "2048"
VM_01_storageOSDiskManagedDiskType          = "Premium_LRS"
## If using Linux Server
VM_01_LinuxStorageImageReferencePublisher   = "Canonical"
VM_01_LinuxStorageImageReferenceOffer       = "0001-com-ubuntu-server-focal"
VM_01_LinuxStorageImageReferenceSKU         = "20_04-lts-gen2"