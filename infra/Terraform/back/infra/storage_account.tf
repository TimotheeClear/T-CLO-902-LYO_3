resource "random_string" "resource_code" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_storage_account" "tfstate_storage_account" {
  name                            = join("",[var.backend_storage_account_name,random_string.resource_code.result])
  resource_group_name             = azurerm_resource_group.tfstate_storage_resource_group.name
  location                        = azurerm_resource_group.tfstate_storage_resource_group.location
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}