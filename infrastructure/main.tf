# =======================
# Random Unique Identifiers
# =======================
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "random_integer" "suffix" {
  count = 1
  min   = 10000
  max   = 99999
}

# =======================
# Resource Group
# =======================
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${random_string.suffix.result}"
  location = var.location
}

# =======================
# Azure Container Registry
# =======================
resource "azurerm_container_registry" "acr" {
  name                = lower("meshregistry${random_integer.suffix[0].result}")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku
  admin_enabled       = true
}

# =======================
# App Service Plan
# =======================
resource "azurerm_service_plan" "asp" {
  name                = "mesh-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
}

# =======================
# Cosmos DB (Mongo API)
# =======================
resource "azurerm_cosmosdb_account" "cosmos" {
  count               = 1
  name                = lower("mesh-cosmos-db-${random_integer.suffix[0].result}")
  resource_group_name = azurerm_resource_group.rg.name
  location            = "Central India"
  offer_type          = "Standard"
  kind                = var.cosmos_db_kind

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = "Central India"
    failover_priority = 0
  }
}

# =======================
# Linux Web Apps (for all microservices)
# =======================
resource "azurerm_linux_web_app" "microservices" {
  for_each = toset(var.microservices)

  # ✅ Unique name fix
  name                = "${each.value}-webapp-${random_integer.suffix[0].result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = false
  }

  app_settings = {
    "WEBSITES_PORT" = "8080"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      app_settings,
      site_config
    ]
  }
}
