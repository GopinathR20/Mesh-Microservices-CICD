# ==========================================================
# Terraform Outputs (Synced with Azure Pipeline)
# ==========================================================

# ✅ Resource Group
output "resource_group_name" {
  description = "Name of the Azure Resource Group."
  value       = azurerm_resource_group.rg.name
}

# ✅ ACR Login Server (matches pipeline)
output "container_registry_login_server" {
  description = "Login server of the Azure Container Registry."
  value       = azurerm_container_registry.acr.login_server
}

# ✅ ACR Credentials (used in pipeline)
output "acr_admin_username" {
  description = "Admin username for the Azure Container Registry."
  value       = azurerm_container_registry.acr.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "Admin password for the Azure Container Registry."
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}

# ✅ Cosmos DB Connection String (used by microservices)
output "cosmos_db_connection_string" {
  description = "Primary MongoDB connection string from Cosmos DB."
  value = (
    length(azurerm_cosmosdb_account.cosmos) > 0 ?
    azurerm_cosmosdb_account.cosmos[0].primary_mongodb_connection_string :
    "Cosmos DB not created"
  )
  sensitive = true
}

# 🔹 Optional outputs (not required by pipeline, but useful)
output "cosmos_db_endpoint" {
  description = "Endpoint for the Cosmos DB account (if created)."
  value = (
    length(azurerm_cosmosdb_account.cosmos) > 0 ?
    azurerm_cosmosdb_account.cosmos[0].endpoint :
    "Cosmos DB not created"
  )
}

output "app_service_plan_name" {
  description = "Name of the Azure App Service Plan."
  value       = azurerm_service_plan.asp.name
}

output "web_app_hostnames" {
  description = "Map of service names to their default hostnames."
  value       = { for k, v in azurerm_linux_web_app.microservices : k => "https://${v.default_hostname}" }
}
