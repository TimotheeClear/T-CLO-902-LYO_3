##============Terraform Back===========##
backend_resource_group_name         = "clou-902-terraform-back-rg"
azure_cloud_location                = "francecentral"
backend_storage_account_name        = "tfbackstorage"
storage_account_tier                = "Standard"
storage_account_replication_type    = "LRS"
storage_container_name              = "tfbackcontainer"
storage_container_access_type       = "private"

tags = {
    Author          = "michael.ranivo@epitech.eu"
    Project         = "Kubequest"
    Country         = "FR"
    Environment     = "POC"
    ApplicationID   = "calculatrice"
    Version         = "1"
    BackupPolicy    = "No-Backup"
}

##====================Infra====================##

##==============support==================##
rg_address_ip_name              = "kubequest_rg_ip"
admin_ip_adr_name               = "kubequest_ip_1"
client_ip_adr_name              = "kubequest_ip_2"
resource_group_name             = "clou-902-kubequest-infra-rg"

##==============Azure LB=================##
lb_name                         = "kubequest_lb"
lb_admin_ip_adr_name            = "kubequest_lb_admin_front_ip"
lb_client_ip_adr_name           = "kubequest_lb_client_front_ip"
lb_admin_backend_pool_name      = "kubequest_lb_admin_backend_pool"
lb_client_backend_pool_name     = "kubequest_lb_client_backend_pool"
lb_backend_pool_master          = "kubequest_lb_backend_pool_master_associate"
lb_backend_pool_worker          = "kubequest_lb_backend_pool_worker_associate"
lb_80_probe_name                = "kubequest_lb_probe_80"
lb_443_probe_name               = "kubequest_lb_probe_443"
lb_rule_80_name                 = "kubequest_lb_80_rule"
lb_rule_443_name                = "kubequest_lb_443_rule"
lb_nat_rule_name_ssh            = "kubequest_lb_ssh_rules"
lb_nat_rule_name_Kube           = "kubequest_lb_kubeapiendpoint_rule"

##==============Azure vnet===============##
vnet_name                       = "kubequest_vnet"
masters_subnet_name             = "kubequest_masters_subnet"
masters_subnet_network_sg_name  = "masterSubnetNSG"
workers_subnet_name             = "kubequest_workers_subnet"
workers_subnet_network_sg_name  = "workerSubnetNSG"
route_table_name                = "workers_route_table"

##==============SSH======================##
node_ssh_public_key_type        = "Microsoft.Compute/sshPublicKeys@2023-03-01"
node_master_ssh_public_key_name = "VMNodeMasterPublicKey"
node_worker_ssh_public_key_name = "VMNodeWorkerPublicKey"

##==============Node Master==============##

## Network Interface Node Master
net_int_node_master_name        = "node_master_net_interface"
net_int_ip_config_master_name   = "node_master_net_interface_config_ip" 

## VM Node Master Configuration
vm_node_master_name             = "master"
vm_node_master_size             = "Standard_D2as_v4"
vm_node_master_os_disk_name     = "NodeMasterVMOsDisk"
vm_node_master_image_pub        = "canonical"
vm_node_master_image_offer      = "0001-com-ubuntu-server-jammy"
vm_node_master_image_sku        = "22_04-lts-gen2"
vm_node_master_image_version    = "latest"

## VM Master username
node_master_username            = "master_user"

##==============Node Worker==============##
nomber_of_vm_worker             = 2

## Network Interface Node Worker
net_int_node_worker_name        = "node_worker_net_interface"
net_int_ip_config_worker_name   = "node_worker_net_interface_config_ip"

## VM Node Master Configuration
vm_node_worker_name             = "vmNodeWorker"
vm_node_worker_size             = "Standard_B2s"
vm_node_worker_os_disk_name     = "NodeWorkerVMOsDisk"
vm_node_worker_image_pub        = "canonical"
vm_node_worker_image_offer      = "0001-com-ubuntu-server-jammy"
vm_node_worker_image_sku        = "22_04-lts-gen2"
vm_node_worker_image_version    = "latest"

## VM Master username
node_worker_username            = "worker_user"