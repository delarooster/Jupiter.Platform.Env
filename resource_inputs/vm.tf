module "VM_01" {
    source                                = "./terraform_vm_azure_module_v2"  
    ## common naming imput vars
    business_unit_input                   =  var.business_unit
    location_descriptor_input             =  var.location
    ## common tag vars
    appid                                 =  var.appid
    division                              =  var.business_unit
    environment_input                     =  var.environment
    cost_center                           =  var.cost_center
    project_cost_center                   =  var.cost_center
    requestor                             =  var.requestor
    confidentiality_input                 =  var.confidentiality
    accessibility_input                   =  var.accessibility
    criticality_input                     =  var.criticality
    audit_input                           =  var.audit
    expiration_date                       =  var.expiration_date
    subnet_name                           =  module.app_sn.concatenated_name
    agn                                   =  var.AGN
    ## puppet tag vars
    role                                  =  var.VM_01_role
    canary                                =  var.canary
    ## common vm deploy vars
    location                              =  module.app_pattern.rg_location
    resource_group_name                   =  module.app_rg.concatenated_name
    subnetId                              =  module.app_pattern.sn_id
    storageAccntURI                       =  module.app_pattern.sa_blob_endpoint
    recovery_vault_name                   =  module.app_pattern.rsv_name
    backup_policy_id                      =  module.backup_policy.backup_policy_id
    availabilitySetId                     =  azurerm_availability_set.application.id
    domainjoin                            =  var.domainjoin
    ## unique vm deploy vars for this instance
    OSMachineType_input                   =  var.VM_01_OSMachineType_input
    virtualMachineSize                    =  var.VM_01_virtualMachineSize
    countInt                              =  var.VM_01_countInt
    naming_index                          =  var.VM_01_naming_index
    ## unique windows os vars - COMMENT OUT IF USING LINUX OS
    # WindowsStorageImageReferenceSKU       =  var.VM_01_WindowsStorageImageReferenceSKU
    # WindowsStorageImageReferencePublisher =  var.VM_01_WindowsStorageImageReferencePublisher
    # WindowsStorageImageReferenceOffer     =  var.VM_01_WindowsStorageImageReferenceOffer
    ## Optional Windows Data Disk - COMMENT OUT IF NOT ADDING
    # vw_data_disk                          = var.VW_01_data_disk
    # vw_data_disk_instances                = var.VW_01_data_disk_instances
    # vw_data_storage_account_type          = var.VW_01_data_storage_account_type
    # vw_data_disk_size                     = var.VW_01_data_disk_size
    ## unique linux os vars - COMMENT OUT IF USING WINDOWS OS
    LinuxStorageImageReferencePublisher =  var.VM_01_LinuxStorageImageReferencePublisher
    LinuxStorageImageReferenceOffer     =  var.VM_01_LinuxStorageImageReferenceOffer
    LinuxStorageImageReferenceSKU       =  var.VM_01_LinuxStorageImageReferenceSKU
    ## Optional Linux Data Disk - COMMENT OUT IF NOT ADDING
    # vl_data_disk                          = var.VL_01_data_disk
    # vl_data_disk_instances                = var.VL_01_data_disk_instances
    # vl_data_storage_account_type          = var.VL_01_data_storage_account_type
    # vl_data_disk_size                     = var.VL_01_data_disk_size
    # common sql server vars
    # sql_sysvwadmin                      =  var.dbadminsec
    count                                = var.vm_count
}