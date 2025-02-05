resource "azurerm_resource_group" "tfstate_storage_resource_group" {
  name      = var.backend_resource_group_name
  location  = var.azure_cloud_location
  tags      = var.tags
}