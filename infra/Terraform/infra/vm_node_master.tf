# Créer en meme temps que la VM apres l'interface réseau

# Créer cette interface après le subnet et l'adresse 
# Create network interface
resource "azurerm_network_interface" "node_master_nic" {
  name                = var.net_int_node_master_name
  location            = azurerm_resource_group.iaas_resource_group.location
  resource_group_name = azurerm_resource_group.iaas_resource_group.name

  ip_configuration {
    name                          = var.net_int_ip_config_master_name
    subnet_id                     = azurerm_subnet.iaas_masters_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [ 
    azurerm_resource_group.iaas_resource_group,
    azurerm_subnet.iaas_masters_subnet,
    azurerm_network_security_group.masters_subnet_nsg
  ]
}

# Créer arpès l'interface réseau en meme temps que l'ip public et le groupe de securité
# Create virtual machine
resource "azurerm_linux_virtual_machine" "node_master_vm" {
  name                  = var.vm_node_master_name
  location              = azurerm_resource_group.iaas_resource_group.location
  resource_group_name   = azurerm_resource_group.iaas_resource_group.name
  network_interface_ids = [azurerm_network_interface.node_master_nic.id]
  size                  = var.vm_node_master_size

  os_disk {
    name                 = var.vm_node_master_os_disk_name
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.vm_node_master_image_pub
    offer     = var.vm_node_master_image_offer
    sku       = var.vm_node_master_image_sku
    version   = var.vm_node_master_image_version
  }

  computer_name         = var.vm_node_master_name
  admin_username        = var.node_master_username

  admin_ssh_key {
    username   = var.node_master_username
    public_key = jsondecode(azapi_resource_action.node_master_ssh_public_key_gen.output).publicKey
  }

  depends_on          = [
    azurerm_resource_group.iaas_resource_group,
    azurerm_subnet.iaas_masters_subnet,
    azurerm_network_security_group.masters_subnet_nsg,
    azurerm_subnet_network_security_group_association.masters_subnet_with_masters_nsg,
    azurerm_network_interface.node_master_nic,
    azapi_resource_action.node_master_ssh_public_key_gen
  ]
}