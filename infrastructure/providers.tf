# infrastructure/providers.tf

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.74.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    # Add azuredevops provider if you are creating pipelines
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 0.4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Add this provider block if you are creating pipelines
provider "azuredevops" {
  org_service_url = var.azdo_org_service_url
}

# This block tells Terraform to use your existing Cloud Shell storage
terraform {
  backend "azurerm" {
    # This is the resource group for your Cloud Shell storage
    resource_group_name  = "cloud-shell-storage-centralindia"
    # This is the storage account name from your screenshot
    storage_account_name = "csg100320035b718cb1"
    # This container already exists
    container_name       = "tfstate"
    key                  = "mesh.prod.terraform.tfstate"
  }
}