resource "azurerm_lb" "iaas-lb" {
  name                = var.lb_name
  resource_group_name = azurerm_resource_group.iaas_resource_group.name
  location            = azurerm_resource_group.iaas_resource_group.location
  sku                 = "Standard"

  #IP Adr for admin and devs
  frontend_ip_configuration {
    name                 = var.lb_admin_ip_adr_name
    public_ip_address_id = data.azurerm_public_ip.lb_admin_ip_adr.id
  }
   
  # #IP Adr for clients
  # frontend_ip_configuration {
  #   name                 = var.lb_client_ip_adr_name
  #   public_ip_address_id = data.azurerm_public_ip.lb_client_ip_adr.id
  # } 

  sku_tier            = "Regional"
  tags                = var.tags

  depends_on = [ 
    azurerm_linux_virtual_machine.node_master_vm,
    azurerm_linux_virtual_machine.node_worker_vm
   ]
}  
  
## Admin Backend pools
resource "azurerm_lb_backend_address_pool" "lb_admin_backend_pool" {
  name            = var.lb_admin_backend_pool_name
  loadbalancer_id = azurerm_lb.iaas-lb.id

  depends_on = [ 
    azurerm_linux_virtual_machine.node_master_vm,
    azurerm_linux_virtual_machine.node_worker_vm,
    azurerm_lb.iaas-lb
  ]
}

## add Master Network Interfaces to the admin Backend pools
resource "azurerm_network_interface_backend_address_pool_association" "add_master_node_admin_backend_pool" {
  ip_configuration_name   = var.net_int_ip_config_master_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_admin_backend_pool.id
  network_interface_id    = azurerm_network_interface.node_master_nic.id

  depends_on = [ 
    azurerm_lb_backend_address_pool.lb_admin_backend_pool,
    azurerm_lb.iaas-lb
  ] 
}

## add Worker Network Interfaces to the admin Backend pools
resource "azurerm_network_interface_backend_address_pool_association" "add_worker_node_admin_backend_pool" {
  count                   = var.nomber_of_vm_worker
  ip_configuration_name   = "${var.net_int_ip_config_worker_name}-${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_admin_backend_pool.id
  network_interface_id    = azurerm_network_interface.node_worker_nic[count.index].id

  depends_on = [ 
    azurerm_lb_backend_address_pool.lb_admin_backend_pool,
    azurerm_lb.iaas-lb
  ]
}

# ## Client Backend pools
# resource "azurerm_lb_backend_address_pool" "lb_client_backend_pool" {
#   name            = var.lb_client_backend_pool_name
#   loadbalancer_id = azurerm_lb.iaas-lb.id

#   depends_on = [ 
#     azurerm_linux_virtual_machine.node_master_vm,
#     azurerm_linux_virtual_machine.node_worker_vm,
#     azurerm_lb.iaas-lb
#   ]
# }

# ## add Worker Network Interfaces to the client Backend pools
# resource "azurerm_network_interface_backend_address_pool_association" "add_worker_node_client_backend_pool" {
#   count                   = var.nomber_of_vm_worker
#   ip_configuration_name   = "${var.net_int_ip_config_worker_name}-${count.index}"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.lb_client_backend_pool.id
#   network_interface_id    = azurerm_network_interface.node_worker_nic[count.index].id

#   depends_on = [ 
#     azurerm_lb_backend_address_pool.lb_client_backend_pool,
#     azurerm_lb.iaas-lb
#   ]
# }

# ## 80 Health probe
# resource "azurerm_lb_probe" "healt_probe_80" {
#   name                = var.lb_80_probe_name
#   loadbalancer_id     = azurerm_lb.iaas-lb.id
#   protocol            = "Tcp"
#   port                = 80
#   interval_in_seconds = 5

#   depends_on = [ 
#     azurerm_network_interface_backend_address_pool_association.add_worker_node_client_backend_pool,
#     azurerm_lb.iaas-lb
#   ]
# }

# ## 443 Health probe
# resource "azurerm_lb_probe" "healt_probe_443" {
#   name                = var.lb_443_probe_name
#   loadbalancer_id     = azurerm_lb.iaas-lb.id
#   protocol            = "Tcp"
#   port                = 443
#   interval_in_seconds = 5

#   depends_on = [ 
#     azurerm_network_interface_backend_address_pool_association.add_worker_node_client_backend_pool,
#     azurerm_lb.iaas-lb
#   ]
# }

# ## add Load Balancer rules for client with the port 80
# resource "azurerm_lb_rule" "http_rules" {
#   name                            = var.lb_rule_80_name
#   loadbalancer_id                 = azurerm_lb.iaas-lb.id
#   frontend_ip_configuration_name  = var.lb_client_ip_adr_name
#   backend_address_pool_ids        = [ azurerm_lb_backend_address_pool.lb_client_backend_pool.id ]
#   protocol                        = "Tcp"
#   frontend_port                   = 80
#   backend_port                    = 80
#   probe_id                        = azurerm_lb_probe.healt_probe_80.id
#   load_distribution               = "SourceIPProtocol"
#   idle_timeout_in_minutes         = 4
#   enable_tcp_reset                = true
#   disable_outbound_snat           = true

#   depends_on = [ 
#     azurerm_network_interface_backend_address_pool_association.add_worker_node_client_backend_pool,
#     azurerm_lb.iaas-lb
#   ]
# }

# ## add Load Balancer rules for client with the port 443
# resource "azurerm_lb_rule" "https_rules" {
#   name                            = var.lb_rule_443_name
#   loadbalancer_id                 = azurerm_lb.iaas-lb.id
#   frontend_ip_configuration_name  = var.lb_client_ip_adr_name
#   backend_address_pool_ids        = [ azurerm_lb_backend_address_pool.lb_client_backend_pool.id ]
#   protocol                        = "Tcp"
#   frontend_port                   = 443
#   backend_port                    = 443
#   probe_id                        = azurerm_lb_probe.healt_probe_443.id
#   load_distribution               = "SourceIPProtocol"
#   idle_timeout_in_minutes         = 4 
#   enable_tcp_reset                = true
#   disable_outbound_snat           = true


#   depends_on = [ 
#     azurerm_network_interface_backend_address_pool_association.add_worker_node_client_backend_pool,
#     azurerm_lb.iaas-lb
#   ]
# }

## add Inbound NAT rule for ssh to the admin backend pool
resource "azurerm_lb_nat_rule" "iaas_lb_nat_rules_ssh" {
  name                            = var.lb_nat_rule_name_ssh
  resource_group_name             = azurerm_resource_group.iaas_resource_group.name
  loadbalancer_id                 = azurerm_lb.iaas-lb.id
  backend_address_pool_id         = azurerm_lb_backend_address_pool.lb_admin_backend_pool.id
  frontend_ip_configuration_name  = var.lb_admin_ip_adr_name
  protocol                        = "Tcp"
  frontend_port_start             = 500
  frontend_port_end               = 510
  backend_port                    = 22
  enable_tcp_reset                = true
  idle_timeout_in_minutes         = 4

  depends_on = [ 
    azurerm_network_interface_backend_address_pool_association.add_master_node_admin_backend_pool,
    azurerm_network_interface_backend_address_pool_association.add_worker_node_admin_backend_pool,
    azurerm_lb.iaas-lb
  ]
}

## add Inbound NAT rule Kube Api Server Endpoint to the master node
resource "azurerm_lb_nat_rule" "iaas_lb_nat_rules_kubeApiEndpoint" {
  name                            = var.lb_nat_rule_name_Kube
  resource_group_name             = azurerm_resource_group.iaas_resource_group.name
  loadbalancer_id                 = azurerm_lb.iaas-lb.id
  frontend_ip_configuration_name  = var.lb_admin_ip_adr_name
  protocol                        = "Tcp"
  frontend_port                   = 6443
  backend_port                    = 6443
  enable_tcp_reset                = true
  idle_timeout_in_minutes         = 5

  depends_on = [ 
    azurerm_network_interface.node_master_nic,
    azurerm_lb.iaas-lb
  ]
}

## NIC association LB Nat rule Kube Api Server Endpoint to the master node
resource "azurerm_network_interface_nat_rule_association" "ip_configuration_nat_rule_kube_api_endpoint" {
  ip_configuration_name = var.net_int_ip_config_master_name
  network_interface_id  = azurerm_network_interface.node_master_nic.id
  nat_rule_id           = azurerm_lb_nat_rule.iaas_lb_nat_rules_kubeApiEndpoint.id

  depends_on = [ 
    azurerm_lb.iaas-lb,
    azurerm_lb_nat_rule.iaas_lb_nat_rules_kubeApiEndpoint,
    azurerm_network_interface.node_master_nic
   ]
}

## add Outbound LB rules for all VMs
resource "azurerm_lb_outbound_rule" "outbound_lb_rules" {
  name                    = "OutboundRuleForAllVMs"
  loadbalancer_id         = azurerm_lb.iaas-lb.id

  # #IP Adr for clients
  # frontend_ip_configuration {
  #   name = var.lb_client_ip_adr_name
  # }

  #IP Adr for admins
  frontend_ip_configuration {
    name = var.lb_admin_ip_adr_name
  }

  protocol                  = "All"
  idle_timeout_in_minutes   = 4
  enable_tcp_reset          = true
  backend_address_pool_id   = azurerm_lb_backend_address_pool.lb_admin_backend_pool.id
  allocated_outbound_ports  = 1024

  depends_on = [ 
    azurerm_network_interface_backend_address_pool_association.add_master_node_admin_backend_pool,
    azurerm_network_interface_backend_address_pool_association.add_worker_node_admin_backend_pool,
    azurerm_lb.iaas-lb
  ]
}