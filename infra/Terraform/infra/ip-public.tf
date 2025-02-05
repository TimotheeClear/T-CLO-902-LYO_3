data "azurerm_public_ip" "lb_admin_ip_adr" {
    name                = var.admin_ip_adr_name
    resource_group_name = var.rg_address_ip_name
}

data "azurerm_public_ip" "lb_client_ip_adr" {
    name                = var.client_ip_adr_name
    resource_group_name = var.rg_address_ip_name
} 