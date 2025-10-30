terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-centralindia"
    storage_account_name = "csg100320035b718cb1"
    container_name       = "tfstate"
    key                  = "mesh.prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "random" {}
