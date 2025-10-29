# infrastructure/providers.tf

terraform {
  required_version = ">= 1.0"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 0.4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.74.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Provider for Azure DevOps (was missing)
provider "azuredevops" {
  org_service_url = var.azdo_org_service_url
}

# Provider for Azure
provider "azurerm" {
  features {}
}

# Backend block pointing to your correct Cloud Shell storage
terraform {
  backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-centralindia"
    storage_account_name = "csg100320035b718cb1" # Your correct storage account
    container_name       = "tfstate"              # The container you created
    key                  = "mesh.prod.terraform.tfstate"
  }
}