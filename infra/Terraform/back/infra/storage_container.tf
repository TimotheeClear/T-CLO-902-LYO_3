resource "azurerm_storage_container" "tfstate_storage_container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.tfstate_storage_account.name
  container_access_type = var.storage_container_access_type
} 