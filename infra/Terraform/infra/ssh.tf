# Créer Avant la VM node Master
resource "azapi_resource" "node_master_ssh_public_key" {
  type        = var.node_ssh_public_key_type
  name        = var.node_master_ssh_public_key_name
  location    = var.azure_cloud_location
  parent_id   = azurerm_resource_group.iaas_resource_group.id
  depends_on  = [ azurerm_resource_group.iaas_resource_group ]
}

resource "azapi_resource_action" "node_master_ssh_public_key_gen" {
  type                      = var.node_ssh_public_key_type
  resource_id               = azapi_resource.node_master_ssh_public_key.id
  action                    = "generateKeyPair"
  method                    = "POST"
  response_export_values    = ["publicKey", "privateKey"]
  depends_on                = [ azapi_resource.node_master_ssh_public_key ]
}

resource "azapi_resource" "node_worker_ssh_public_key" {
  count       = var.nomber_of_vm_worker
  type        = var.node_ssh_public_key_type
  name        = "${var.node_worker_ssh_public_key_name}-${count.index}"
  location    = var.azure_cloud_location
  parent_id   = azurerm_resource_group.iaas_resource_group.id
  depends_on  = [ azurerm_resource_group.iaas_resource_group ]
}

resource "azapi_resource_action" "node_worker_ssh_public_key_gen" {
  count                     = var.nomber_of_vm_worker
  type                      = var.node_ssh_public_key_type
  resource_id               = azapi_resource.node_worker_ssh_public_key[count.index].id
  action                    = "generateKeyPair"
  method                    = "POST"
  response_export_values    = ["publicKey", "privateKey"]
}