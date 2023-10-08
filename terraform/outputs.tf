output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_address" {
  description = "Public IP address of the Azure Virtual Machine"
  value       = azurerm_public_ip.analytics-public-ip.ip_address
}


output "admin_username" {
  description = "Admin username used for the virtual machine"
  value       = var.admin_username
}

output "tls_private_key" {
  value     = tls_private_key.vm1key
  sensitive = true
}



# output "azurerm_virtual_network_name" {
#   value = var.linux_vm.azurerm_virtual_network_name
# }


# output "client_certificate" {
#   value     = azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate
#   sensitive = true
# }

# output "client_key" {
#   value     = azurerm_kubernetes_cluster.k8s.kube_config[0].client_key
#   sensitive = true
# }

# output "cluster_ca_certificate" {
#   value     = azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
#   sensitive = true
# }

# output "cluster_password" {
#   value     = azurerm_kubernetes_cluster.k8s.kube_config[0].password
#   sensitive = true
# }

# output "cluster_username" {
#   value     = azurerm_kubernetes_cluster.k8s.kube_config[0].username
#   sensitive = true
# }

# output "host" {
#   value     = azurerm_kubernetes_cluster.k8s.kube_config[0].host
#   sensitive = true
# }

# output "kube_config" {
#   value     = azurerm_kubernetes_cluster.k8s.kube_config_raw
#   sensitive = true
# }

# output "resource_group_name" {
#   value = azurerm_resource_group.rg.name
# }

