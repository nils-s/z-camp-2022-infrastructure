variable "resource_group_name" {
  description = "Name of the Azure resource group that contains the cluster and container registry"
  type        = string
}

resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group_name
  location = var.azure_location
}

output "resource-group" {
  value       = azurerm_resource_group.k8s.name
  description = "Resource group"
}