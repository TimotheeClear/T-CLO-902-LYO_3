variable "backend_resource_group_name" {
    type        = string
    description = "The name of the resource group for the backend Terraform"
}

variable "azure_cloud_location" {
    type        = string
    description = "The location of Azure Cloud we used"
}
 
variable "backend_storage_account_name" {
    type        = string
    description = "The name of the storage account for the backend Terraform"  
} 
 
variable "storage_account_tier" {
    type        = string
    description = "The storage account tier"
}

variable "storage_account_replication_type" {
    type        = string
    description = "The storahe replication type"
}

variable "storage_container_name" {
    type        = string
    description = "The storage container name"
}

variable "storage_container_access_type" {
    type        = string
    description = "The storage container access type"
}

variable "tags" {
    type        = map(string)
    description = "Informations who will tag all resources"
}