# infrastructure/main.tf

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = lower("meshregistry${substr(md5(var.resource_group_name), 0, 5)}")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true # Easiest for pipeline authentication
}

resource "azurerm_service_plan" "asp" {
  name                = "mesh-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku # F1 (Free)
}

resource "azurerm_cosmosdb_account" "cosmos" {
  name                = lower("mesh-cosmos-db-${random_integer.suffix.result}")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  offer_type          = "Standard"
  kind                = var.cosmos_db_kind
  capabilities { name = "EnableMongo" }
  consistency_policy { consistency_level = "Session" }
  geo_location {
    location = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}
resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

# Create Linux Web Apps for Containers
resource "azurerm_linux_web_app" "microservices" {
  for_each = toset(var.microservices)

  name                = "${each.key}-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  # This configuration will be updated by the pipeline in Stage 3
  site_config {
    always_on        = false # Free tier does not support Always On
    linux_fx_version = "DOCKER|mcr.microsoft.com/oryx/noop:latest" # Placeholder image
  }

  app_settings = {
    "WEBSITES_PORT" = "8080" # Tell App Service which port container uses
  }
}