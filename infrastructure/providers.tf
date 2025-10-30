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

  # ✅ Backend block (Terraform remote state)
  backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-centralindia"
    storage_account_name = "csg100320035b718cb1"
    container_name       = "tfstate"
    key                  = "mesh.prod.terraform.tfstate"
  }
}

# ✅ Azure DevOps Provider
provider "azuredevops" {
  org_service_url = var.azdo_org_service_url
}

# ✅ Azure Provider — Explicitly use pipeline SPN credentials
provider "azurerm" {
  features {}
}
