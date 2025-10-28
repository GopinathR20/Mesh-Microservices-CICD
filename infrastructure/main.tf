# infrastructure/main.tf (Final Deployment Version - Step 2)

# ------------------------------------------------------------------
#  PROVIDER CONFIGURATION
# ------------------------------------------------------------------

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
  org_service_url = "https://dev.azure.com/reccloudcomputingproject"
}

provider "azurerm" {
  features {}
}

# ------------------------------------------------------------------
#  AZURE INFRASTRUCTURE
# ------------------------------------------------------------------

variable "location" { default = "Central India" }
variable "resource_group_name" { default = "mesh-project-rg" }
variable "acr_sku" { default = "Basic" }
variable "github_repo_id" { default = "GopinathR20/Mesh-Microservices-CICD" }
variable "github_branch_name" { default = "main" }
variable "github_connection_id" { default = "GitHub-OAuth-Connection" }
variable "azdo_project_name" { default = "Mesh" }
variable "microservices" {
  type    = list(string)
  default = ["api-gateway", "admin-service", "classroom-service", "discovery-server", "user-service", "ai-service"]
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = lower("meshregistry${substr(md5(var.resource_group_name), 0, 5)}")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = true
}

resource "azurerm_container_app_environment" "aca_env" {
  name                = "mesh-aca-env"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Cosmos DB (Optional)
resource "azurerm_cosmosdb_account" "cosmos" {
  name                = lower("mesh-cosmos-db-${random_integer.suffix.result}")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  consistency_policy { consistency_level = "Session" }
  geo_location { location = azurerm_resource_group.rg.location; failover_priority = 0 }
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

# ------------------------------------------------------------------
#  DEPLOYMENT RESOURCES (Full Configuration)
# ------------------------------------------------------------------

resource "azurerm_container_app" "microservices" {
  for_each = toset(var.microservices)

  name                         = "${each.key}-app"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  # Final TEMPLATE configuration: Uses actual built image
  template {
    container {
      name   = each.key
      image  = "${azurerm_container_registry.acr.login_server}/${each.key}:latest" # Actual image path
      cpu    = 0.5
      memory = "1.0Gi"
    }
  }

  # ACR AUTHENTICATION: Inject ACR credentials into the Container App
  registry {
    server               = azurerm_container_registry.acr.login_server
    username             = azurerm_container_registry.acr.admin_username
    password_secret_name = "acr-password"
  }
  secret {
    name  = "acr-password"
    value = azurerm_container_registry.acr.admin_password
  }

  # INGRESS: Set external access for API Gateway only
  ingress {
    external_enabled = each.key == "api-gateway" ? true : false
    target_port      = 8080
  }
}

# ------------------------------------------------------------------
#  AZURE DEVOPS PIPELINES (Unchanged)
# ------------------------------------------------------------------

data "azuredevops_project" "project" {
  name = var.azdo_project_name
}

resource "azuredevops_build_definition" "pipelines" {
  for_each = toset(var.microservices)

  project_id = data.azuredevops_project.project.id
  name       = "${title(replace(each.key, "-", " "))}-CI"

  repository {
    repo_type             = "GitHub"
    repo_id               = var.github_repo_id
    branch_name           = var.github_branch_name
    service_connection_id = var.github_connection_id
    yml_path              = "Mesh-Microservices/${each.key}/azure-pipelines.yml"
  }
}