# infrastructure/outputs.tf

output "resource_group_name" { value = azurerm_resource_group.rg.name }
output "acr_name" { value = azurerm_container_registry.acr.name }
output "acr_login_server" { value = azurerm_container_registry.acr.login_server }
output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
  sensitive = true
}
output "acr_admin_password" {
  value = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "cosmos_db_connection_string" {
  # Access the first instance [0] of the resource created with count
  value     = azurerm_cosmosdb_account.cosmos[0].primary_mongodb_connection_string
  sensitive = true
}

output "web_app_hostnames" {
  value = { for k, v in azurerm_linux_web_app.microservices : k => "https://${v.default_hostname}" }
}