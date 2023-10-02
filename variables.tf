# Default Application Variables
variable "environment" {
  type        = string
  description = "Pipeline variable for defining Terraform working subscription and naming conventions"
  default     = ""
}
variable "business_unit" {
  type        = string
  description = "Business unit name as mapped under the naming module"
  default     = ""
}
variable "cost_center" {
  type        = string
  description = "Freehand definition for cost center"
  default     = ""
}
variable "requestor" {
  type        = string
  description = "Name of the individual who requested the resource"
  default     = ""
}
variable "confidentiality" {
  type        = string
  description = "Parent input for confidentiality tag"
  default     = ""
}
variable "accessibility" {
  type        = string
  description = "Parent input for accessibility tag"
  default     = ""
}
variable "criticality" {
  type        = string
  description = "Parent input for criticality tag"
  default     = ""
}
variable "appid" {
  type        = string
  description = "Application ID tag"
  default     = ""
}
variable "platform_fault_domain_count" {
  type        = string
  default     = "3"
}
variable "audit" {
  type        = string
  description = "Parent input for audit tag"
  default     = ""
}
variable "expiration_date" {
  type        = string
  description = "The anticipated date for removal of this resource, or none"
  default     = ""
}
variable "location" {
  type        = string
  description = "Azure datacenter location for resources"
  default     = ""
}
variable "cuaGuid" {
  type        = string
  description = "Mesh Customer Usage Attribution"
  default     = ""
}
variable "virtual_network" {
  type        = string
  description = "Environment specific name of virtual network to attach resources"
  default     = ""
}
variable "virtual_network_rg" {
  type        = string
  description = "Name of the vnet resource group for subnet to drop into"
  default     = ""
}
variable "subnet_prefix" {
  type        = string
  description = "Environment specific subnet prefix for application"
  default     = ""
}
variable "subnet_count" {
  type        = string
  default     = ""
}
variable "nsr_count" {
  type        = string
  default     = ""
}
variable "workload" {
  type        = string
  description = "Freehand description of workload for resource naming"
  default     = ""
}
variable "rt_id" {
  type        = string
  description = "Name of route table for attachment to subnet"
  default     = ""
}
variable "vmEnv" {
  type    = string
  default = ""
}
variable "azure_sub_id" {
  description = "Azure subscription ID"
  default     = ""
}
variable "azure_client_id" {
  description = "Azure SP user ID"
  default     = ""
}
variable "azure_client_secret" {
  description = "Azure SP user secret"
  default     = ""
}
variable "azure_tenant_id" {
  description = "Azure tenant ID"
  default     = ""
}
variable "acr_count" {
  type = string
  default = "0"
}

variable "shared_resource_group" {
  type = string
}
variable "region" {
  type = string
}

# IoT Hub
variable "iot_hub_name" {
    type    = string
}
variable "ioth_sku" {
    type    = string
}
variable "ioth_capacity" {
    type    = string
}
variable "iothub_qa_auth_rule_count" {
  type    = string
  default = 0
}

# ADX
variable "adx_cluster_sku" {
  type = string
  default = "Dev(No SLA)_Standard_E2a_v4"
}
variable "adx_cluster_capacity" {
  type = string
  default = 1
}

# DPS
variable "dps_sku" {
    type    = string
    default = "S1"
}
variable "dps_capacity" {
    type    = string
    default = "1"
}

# Azure Container Registry
variable "acrSku" {
    type    = string
    default = "Basic"
}
variable "acr_name" {
    type    = string
    default = "crappname"
}
variable "old_acr_name" {
    type    = string
    default = ""
}
variable "old_acr_count" {
    type    = string
    default = 0
}
# Event Hub
variable "eventHubSku" {
    type    = string
    default = "Standard"
}
variable "callistoPartitions" {
  type    = string
  default = 10
}
variable "load_test_auth_rule_count" {
  type    = string
  default = 0
}

# Service Principals
variable "aksApp2937Sp" {
  type    = string
  default = ""
}

# Temp
variable "atdObjectId" {
  type    = string
  default = ""
}

variable "mcObjectId" {
  type    = string
  default = ""
}

variable "dwcObjectId" {
  type    = string
  default = ""
}
## Linux VM
variable "domainjoin" {
  type        = string
  description = "windowsdomainjoin"
  default     = ""
}

variable "OSMachineType" {
  type = map(string)
  description = "Used for OS Type"
  default = {
      "Windows"    = "Windows"
      "Linux"      = "Linux"
      "WindowsSQL" = "WindowsSQL"
  }
}

variable "vm_count" {
  type = string
  description = "Number of VMs to be deployed"
  default = 0
}

variable "AGN" {
  type        = string
  description = "Tag for Application Group Number"
  default     = ""
}

variable "canary" {
  type        = string
  description = "Tag for canary branch in puppet"
  default     = "false"
}

variable "VM_01_OSMachineType_input" {
  type        = string
  description = "String value of OSMachineType passed from parent"
  default     = "Windows"
}

variable "VM_01_virtualMachineSize" {
  type        = string
  description = "The offering size of the VM"
  default     = "Standard_D2_v2"

}

variable "VM_01_naming_index" {
  type        = string
  description = "Count of resource to be appended at end of name. Use for overriding name_count."
  default     = "1"
}

variable "VM_01_countInt" {
  type        = string
  description = "Used for OS Type"
  default     = "1"
}

variable "VM_01_role" {
  type        = string
  description = "Used by Puppet"
  default     = ""
}

variable "VM_01_enable_accelerated_networking" {
  type        = string
  description = "Optional to enable accelerated networking on network interface"
  default     = "true"
}

variable "VM_01_WindowsStorageImageReferenceSKU" {
  type        = string
  description = "The type and or version of the Virtual Machine being requested"
  default     = "2019-Datacenter"
}

variable "VM_01_WindowsStorageImageReferencePublisher" {
  type        = string
  description = "The publisher of provider resources. Note that the name typically contains the offer"
  default     = "MicrosoftWindowsServer"
}

variable "VM_01_WindowsStorageImageReferenceOffer" {
  type        = string
  description = "The offer of the Virtual Machine being requested"
  default     = "WindowsServer"
}

variable "VM_01_WindowsStorageImageReferenceVersion" {
  type        = string
  description = "The version of the resource being requested"
  default     = "latest"
}

variable "VM_01_LinuxStorageImageReferencePublisher" {
  type        = string
  description = "The publisher of provider resources. Note that the name typically contains the offer"
  default     = "Canonical"
}

variable "VM_01_LinuxStorageImageReferenceOffer" {
  type        = string
  description = "The offer of the Virtual Machine being requested"
  default     = "UbuntuServer"
}

variable "VM_01_LinuxStorageImageReferenceSKU" {
  type        = string
  description = "The publisher of provider resources. Note that the name typically contains the offer"
  default     = "16.04-LTS"
}

variable "VL_01_data_disk" {
  type        = string
  description = "Add Data disk to VM"
  default     = "False"
}

variable "VL_01_data_disk_size" {
  type        = string
  description = "VM Data disk size"
  default     = "128"
}

variable "VL_01_data_storage_account_type" {
  type        = string
  description = "VM Data Disk Storage Type"
  default     = "Standard_LRS"
}
variable "VM_01_storageOSDiskManagedDiskType" {
  type        = string
  description = "The OS disk type"
  default     = "Standard_LRS"
}
variable "VM_01_storageOSDiskSize" {
  type        = string
  description = "The OS disk size in GB"
  default     = "127"
}
variable "VM_01_azvm_backup_input" {
  type        = string
  description = "Backup Type"
  default     = "AzureVM_Backup"
}
