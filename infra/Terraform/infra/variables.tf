## IAAS RG
variable "azure_cloud_location" {
    type        = string
    description = "The Azure Cloud's location for our infra"
}

## IAAS LOAD BALANCER
variable "rg_address_ip_name" {
    type        = string
    description = "The name of the Resource Groupe of the address IP of the Load Balancer"
}

variable "admin_ip_adr_name" {
    type        = string
    description = "The name of admin IP of the Load Balancer"
}

variable "client_ip_adr_name" {
    type        = string
    description = "The name of client IP of the Load Balancer"
}

variable "resource_group_name" {
    type        = string
    description = "The name of the resource group where we deploy the infra"
}

variable "lb_name" {
    type        = string
    description = "The name of the LB of the infra"
}

variable "lb_admin_ip_adr_name" {
    type        = string
    description = "The name of the admin IP address of the LB"
}

variable "lb_client_ip_adr_name" {
    type        = string
    description = "The name of the client IP address of the LB"
}

variable "lb_admin_backend_pool_name" {
    type        = string
    description = "The name of the admin backend pool of the Iaas LB"
}

variable "lb_client_backend_pool_name" {
    type        = string
    description = "The name of the client backend pool of the Iaas LB"
}

variable "lb_backend_pool_master" {
    type        = string
    description = "The name of the association between backend pool of the LB and the Network Interface of the master node" 
}

variable "lb_backend_pool_worker" {
    type        = string 
    description = "The name of associations between backend pool of the LB and the Network Interfaces of worker node"
}

variable "lb_80_probe_name" {
    type        = string
    description = "The name of the 80 probe for the LB"  
}

variable "lb_443_probe_name" {
    type        = string
    description = "The name of the 443 probe for the LB"  
}

variable "lb_rule_80_name" {
    type        = string
    description = "The name of the rule incoming from port 80"
}

variable "lb_rule_443_name" {
    type        = string
    description = "The name of the rule incoming from port 443"
}

variable "lb_nat_rule_name_ssh" {
    type        = string
    description = "The name of the ssh nat rule incoming to the backend pool"
}

variable "lb_nat_rule_name_Kube" {
    type        = string
    description = "The name of the kube api server endpoint nat rule incoming to the backend pool"
}
#

## IAAS VNET & SUBNET
variable "vnet_name" {
    type        = string
    description = "The name of the virtual network for the cluster kubernetes"
}

variable "masters_subnet_name" {
    type        = string
    description = "The name of the masters subnet network for the cluster kubernetes"
}

variable "masters_subnet_network_sg_name" {
    type        = string
    description = "The name of the security group of the node master"  
}

variable "workers_subnet_name" {
    type        = string
    description = "The name of the workers subnet network for the cluster kubernetes"
}

variable "workers_subnet_network_sg_name" {
    type        = string
    description = "The network security group node worker"
}

variable "route_table_name" {
    type        = string
    description = "The name of the route table for the cluster kubernetes"
}

## SSH 
variable "node_ssh_public_key_type" {
    type        = string
    description = "The ssh type public key" 
}

variable "node_master_ssh_public_key_name" {
    type        = string
    description = "THe ssh public key name"  
}

variable "node_worker_ssh_public_key_name" {
    type        = string
    description = "THe ssh public key name"  
}

## IAAS NODE MASTER

variable "net_int_node_master_name" {
    type        = string
    description = "The network interface for the Node Master"
}   

variable "net_int_ip_config_master_name" {
    type        = string
    description = "The name of the configuration ip of the network interface"
}

variable "vm_node_master_name" {
    type        = string
    description = "The name of the VM node master"
}  

variable "vm_node_master_size" {
    type        = string
    description = "The size of the Node Master VM"
}

variable "vm_node_master_os_disk_name" {
    type        = string
    description = "The OS Disk name of the VM"  
}

variable "vm_node_master_image_pub" {
    type        = string  
    description = "The name of the image"
}

variable "vm_node_master_image_offer" {
    type        = string
    description = "The Version of the image" 
}

variable "vm_node_master_image_sku" {
    type        = string
    description = "The Version number of the image"
}

variable "vm_node_master_image_version" {
    type        = string
    description = "The version we use of the image"
}

variable "node_master_username" {
    type        = string
    description = "The user we create on the VM"
}

variable "net_int_node_worker_name" {
    type        = string
    description = "The name of the network interface of a Node Worker"
}

variable "net_int_ip_config_worker_name" {
    type        = string
    description = "The name of the ip configuration for the network interface"
}

## IAAS NODE WORKER
variable "nomber_of_vm_worker" {
    type        = number
    description = "The number of Node Worker we need"
}

variable "vm_node_worker_name" {
    type        = string
    description = "Prefix of node worker name"
}

variable "vm_node_worker_size" {
    type        = string
    description = "The size of all Node Worker"
}

variable "vm_node_worker_os_disk_name" {
    type        = string
    description = "The OS Disk's name for all Node Worker"
}

variable "vm_node_worker_image_pub" {
    type        = string
    description = "The distro we will use on the server"
}

variable "vm_node_worker_image_offer" {
    type        = string
    description = "The version of he distro"
}

variable "vm_node_worker_image_sku" {
    type        = string
    description = "The gens on the distro we will use"  
}

variable "vm_node_worker_image_version" {
    type        = string
    description = "The version of the distro"
}

variable "node_worker_username" {
    type        = string
    description = "The user who will create for the server"
}

## PROJECT TAGS
variable "tags" {
    type        = map(string)
    description = "Informations who will tag all resources"
}