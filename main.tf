variable "azure_subscription_id" {
  description = "ID of the Azure subscription used to create the resources"
  type        = string
}

variable "azure_ad_tenant_id" {
  description = "Tenant-ID for our Azure AD tenant"
  type        = string
}

variable "terraformer_sp_password" {
  description = "Password for Azure service principal used by terraform"
  type        = string
  sensitive   = true
}

variable "terraformer_sp_client_id" {
  description = "Client-ID for Azure service principal used by terraform"
  type        = string
  sensitive   = true
}

variable "azure_location" {
  description = "default location/AZ where to create resources"
  type        = string
  default     = "West Europe"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.10.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.24.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  client_id       = var.terraformer_sp_client_id
  client_secret   = var.terraformer_sp_password
  tenant_id       = var.azure_ad_tenant_id
}

provider "azuread" {
  client_id     = var.terraformer_sp_client_id
  client_secret = var.terraformer_sp_password
  tenant_id     = var.azure_ad_tenant_id
}