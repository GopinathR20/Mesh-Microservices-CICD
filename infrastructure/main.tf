resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_integer" "suffix" {
  count = 1
  min   = 10000
  max   = 99999
}

resource "azurerm_container_registry" "acr" {
  name                = lower("meshregistry${random_integer.suffix[0].result}")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = true
}

resource "azurerm_service_plan" "asp" {
  name                = "mesh-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
}

# Optional Cosmos DB (uses free tier if eligible)
resource "azurerm_cosmosdb_account" "cosmos" {
  count               = 1 # Set count = 0 to disable
  name                = lower("mesh-cosmos-db-${random_integer.suffix[0].result}")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  offer_type          = "Standard"
  kind                = var.cosmos_db_kind

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

# Create Linux Web Apps for Containers (Empty Shells for Step 1)
resource "azurerm_linux_web_app" "microservices" {
  for_each = toset(var.microservices)

  name                = "${each.value}-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = false # Free tier does not support Always On
  }

  app_settings = {
    "WEBSITES_PORT" = "8080"
  }
}
