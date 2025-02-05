output "node_master_private_ip_address" {
  value = azurerm_linux_virtual_machine.node_master_vm.private_ip_address
}

output "node_worker_0_pribate_ip_address" {
  value = azurerm_linux_virtual_machine.node_worker_vm[0].private_ip_address
}

output "node_worker_1_pribate_ip_address" {
  value = azurerm_linux_virtual_machine.node_worker_vm[1].private_ip_address
}

output "node_master_hostname" {
  value = azurerm_linux_virtual_machine.node_master_vm.computer_name
} 

output "node_worker_0_hostname" {
  value = azurerm_linux_virtual_machine.node_worker_vm[0].computer_name
} 

output "node_worker_1_hostname" {
  value = azurerm_linux_virtual_machine.node_worker_vm[1].computer_name
}

output "node_master_user" {
  value = azurerm_linux_virtual_machine.node_master_vm.admin_username
}

output "node_worker_0_user" {
  value = azurerm_linux_virtual_machine.node_worker_vm[0].admin_username
}

output "node_worker_1_user" {
  value = azurerm_linux_virtual_machine.node_worker_vm[1].admin_username
}

output "node_master_ssh_lb_port_start" {
  value = azurerm_lb_nat_rule.iaas_lb_nat_rules_ssh.frontend_port_start
}

resource "local_file" "node_master_private_key" {
  content  = jsondecode(azapi_resource_action.node_master_ssh_public_key_gen.output).privateKey
  filename = "node_master_private_key.pem"
}

resource "local_file" "node_worker_0_private_key" {
  content  = jsondecode(azapi_resource_action.node_worker_ssh_public_key_gen[0].output).privateKey
  filename = "node_worker_0_private_key.pem"
}

resource "local_file" "node_worker_1_private_key" {
  content  = jsondecode(azapi_resource_action.node_worker_ssh_public_key_gen[1].output).privateKey
  filename = "node_worker_1_private_key.pem"
}