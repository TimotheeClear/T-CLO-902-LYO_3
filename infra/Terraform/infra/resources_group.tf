resource "azurerm_resource_group" "iaas_resource_group" {
  name      = var.resource_group_name
  location  = var.azure_cloud_location
  tags      = var.tags
}