# infrastructure/providers.tf

terraform {
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

provider "azuredevops" {
  org_service_url = var.azdo_org_service_url
  # The PAT will be supplied via the AZDO_PERSONAL_ACCESS_TOKEN environment variable
}

provider "azurerm" {
  features {}
  # The Subscription ID will be supplied via the ARM_SUBSCRIPTION_ID environment variable
}