# infrastructure/main.tf (Step 1: Initial Creation - Web Apps - Corrected)

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

# App Service Plan - Controls compute resources for Web Apps
resource "azurerm_service_plan" "asp" {
  name                = "mesh-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku # F1 for Free
}

# Optional Cosmos DB (uses free tier if eligible)
resource "azurerm_cosmosdb_account" "cosmos" {
  count               = 1 # Set count = 0 to disable
  name                = lower("mesh-cosmos-db-${random_integer.suffix[0].result}")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  offer_type          = "Standard"
  kind                = var.cosmos_db_kind

  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}
resource "random_integer" "suffix" {
  count = 1
  min   = 10000
  max   = 99999
}

# Create Linux Web Apps for Containers (Empty Shells for Step 1)
resource "azurerm_linux_web_app" "microservices" {
  for_each = toset(var.microservices)

  name                = "${each.key}-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  # Minimal site_config using a placeholder image for initial creation
  site_config {
    always_on        = var.app_service_plan_sku == "F1" ? false : true
    #linux_fx_version = "DOCKER|mcr.microsoft.com/oryx/noop:latest" # Placeholder image
    # app_settings removed from here
  }

  # CORRECT PLACEMENT for app_settings
  app_settings = {
    "WEBSITES_PORT" = "8080" # Tell App Service which port container uses
  }
}

# Azure DevOps Project Data Source
data "azuredevops_project" "project" {
  name = var.azdo_project_name
}

# Azure DevOps Pipeline (Single Definition)
resource "azuredevops_build_definition" "main_ci_cd_pipeline" {
  project_id = data.azuredevops_project.project.id
  name       = "Mesh Microservices CI-CD (Web Apps)"

  repository {
    repo_type             = "GitHub"
    repo_id               = var.github_repo_id
    branch_name           = var.github_branch_name
    service_connection_id = var.github_connection_id
    yml_path              = "azure-pipelines.yml" # Root pipeline file
  }
}