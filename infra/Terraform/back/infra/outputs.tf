output "resource_group_name" {
    value = azurerm_resource_group.tfstate_storage_resource_group.name
}

output "storage_account_name" {
    value = azurerm_storage_account.tfstate_storage_account.name
}
 
output "storage_container_name" {
    value = azurerm_storage_container.tfstate_storage_container.name
}