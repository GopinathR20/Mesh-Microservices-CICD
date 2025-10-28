# infrastructure/main.tf (Step 1: Initial Creation)

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Container Registry
resource "azurerm_container_registry" "acr" {
  name                = lower("meshregistry${substr(md5(var.resource_group_name), 0, 5)}") # Ensure lowercase
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = true
}

# 3. Container App Environment
resource "azurerm_container_app_environment" "aca_env" {
  name                = "mesh-aca-env"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# 4. Cosmos DB (Optional - remove if not needed)
resource "azurerm_cosmosdb_account" "cosmos" {
  name                = lower("mesh-cosmos-db-${random_integer.suffix.result}") # Ensure lowercase
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB" # Change to MongoDB if needed by your app

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
  # enable_free_tier = true <-- Removed this line
}

# Suffix for unique Cosmos DB naming
resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

# 5. Container Apps (using placeholder image)
resource "azurerm_container_app" "microservices" {
  for_each = toset(var.microservices)

  name                         = "${each.key}-app"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  # Minimal template with placeholder image for initial creation
  template {
    container {
      name   = "placeholder"
      image  = "mcr.microsoft.com/k8se/apps/null-image:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
    min_replicas = 0 # Scale to zero when idle (Free tier benefit)
    max_replicas = 1 # Start with one replica max
  }
}

# 6. Azure DevOps Project Data Source
data "azuredevops_project" "project" {
  name = var.azdo_project_name
}

# 7. Azure DevOps Pipelines (one for each service)
resource "azuredevops_build_definition" "pipelines" {
  for_each = toset(var.microservices)

  project_id = data.azuredevops_project.project.id
  name       = "${title(replace(each.key, "-", " "))}-CI" # Creates names like "Api Gateway CI"

  repository {
    repo_type             = "GitHub"
    repo_id               = var.github_repo_id
    branch_name           = var.github_branch_name
    service_connection_id = var.github_connection_id
    # Ensure this path matches your structure (Mesh-Microservices folder contains service folders)
    yml_path              = "Mesh-Microservices/${each.key}/azure-pipelines.yml"
  }
}