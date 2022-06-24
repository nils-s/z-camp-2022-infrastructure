variable "container_registry_name" {
  description = "Name of the Azure container registry; must be globally unique!"
  type        = string
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "cluster_dns_prefix" {
  description = "DNS prefix of the Kubernetes cluster"
  type        = string
}

resource "azurerm_container_registry" "camp-registry" {
  name                = var.container_registry_name
  sku                 = "Basic"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
}

resource "azurerm_kubernetes_cluster" "camp-k8s-cluster" {
  name                      = var.cluster_name
  location                  = azurerm_resource_group.k8s.location
  resource_group_name       = azurerm_resource_group.k8s.name
  dns_prefix                = var.cluster_dns_prefix
  kubernetes_version        = "1.24.0"
  automatic_channel_upgrade = "patch"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Dev"
  }
}

resource "azurerm_role_assignment" "image-pull-role" {
  scope                            = azurerm_container_registry.camp-registry.id
  principal_id                     = azurerm_kubernetes_cluster.camp-k8s-cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "image-push-role" {
  scope                            = azurerm_container_registry.camp-registry.id
  principal_id                     = azuread_service_principal.image-upload-user.id
  role_definition_name             = "AcrPush"
  skip_service_principal_aad_check = true
}

output "cluster-name" {
  value       = azurerm_kubernetes_cluster.camp-k8s-cluster.name
  description = "Name of the Kubernetes cluster"
}