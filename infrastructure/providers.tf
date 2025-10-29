# infrastructure/providers.tf

terraform {
  required_version = ">= 1.0"
  required_providers {
    # Add the azuredevops provider
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

# Add this provider block
provider "azuredevops" {
  org_service_url = var.azdo_org_service_url
}

provider "azurerm" {
  features {}
}

# This block tells Terraform to use your existing Cloud Shell storage
terraform {
  backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-centralindia"
    storage_account_name = "csg100320035b718cb1"
    container_name       = "tfstate"
    key                  = "mesh.prod.terraform.tfstate"
  }
}