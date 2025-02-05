# Créer en meme temps que la VM apres l'interface réseau
# Créer cette interface après le subnet et l'adresse 
# Create network interface
resource "azurerm_network_interface" "node_worker_nic" {
  count               = var.nomber_of_vm_worker
  name                = "${var.net_int_node_worker_name}-${count.index}"
  location            = azurerm_resource_group.iaas_resource_group.location
  resource_group_name = azurerm_resource_group.iaas_resource_group.name

  ip_configuration {
    name                          = "${var.net_int_ip_config_worker_name}-${count.index}"
    subnet_id                     = azurerm_subnet.iaas_workers_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [ 
    azurerm_resource_group.iaas_resource_group,
    azurerm_subnet.iaas_workers_subnet,
    azurerm_network_security_group.workers_subnet_nsg
  ]
}

# Créer arpès l'interface réseau en meme temps que l'ip public et le groupe de securité
# Create virtual machine
resource "azurerm_linux_virtual_machine" "node_worker_vm" {
  count                             = var.nomber_of_vm_worker
  name                              = "${var.vm_node_worker_name}-${count.index}"
  location                          = azurerm_resource_group.iaas_resource_group.location
  resource_group_name               = azurerm_resource_group.iaas_resource_group.name
  network_interface_ids             = [azurerm_network_interface.node_worker_nic[count.index].id]
  size                              = var.vm_node_worker_size

  os_disk {
    name                 = "${var.vm_node_worker_os_disk_name}-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.vm_node_worker_image_pub
    offer     = var.vm_node_worker_image_offer
    sku       = var.vm_node_worker_image_sku
    version   = var.vm_node_worker_image_version
  }

  computer_name         = "${var.vm_node_worker_name}-${count.index}"
  admin_username        = var.node_worker_username

  admin_ssh_key {
    username   = var.node_worker_username
    public_key = jsondecode(azapi_resource_action.node_worker_ssh_public_key_gen[count.index].output).publicKey
  }

  depends_on          = [ 
    azurerm_resource_group.iaas_resource_group,
    azurerm_subnet.iaas_workers_subnet,
    azurerm_network_security_group.workers_subnet_nsg,
    azurerm_subnet_network_security_group_association.workers_subnet_with_workers_nsg,
    azurerm_network_interface.node_worker_nic,
    azapi_resource_action.node_worker_ssh_public_key_gen
  ]
}