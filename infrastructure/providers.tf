# infrastructure/providers.tf

terraform {
  required_version = ">= 1.0"

  required_providers {
    # We remove the azuredevops provider, as the pipeline now creates itself.
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

provider "azurerm" {
  features {}
  # Authentication is handled by the pipeline's service connection
}

# This block tells Terraform to use your existing Cloud Shell storage
# Ensure this container 'tfstate' exists in the 'csg100320035b718cb1' account
terraform {
  backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-centralindia"
    storage_account_name = "csg100320035b718cb1"
    container_name       = "tfstate"
    key                  = "mesh.prod.terraform.tfstate"
  }
}