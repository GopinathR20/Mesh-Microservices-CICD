# infrastructure/outputs.tf

output "resource_group_name" { value = azurerm_resource_group.rg.name }
output "container_registry_login_server" { value = azurerm_container_registry.acr.login_server }
output "app_service_plan_name" { value = azurerm_service_plan.asp.name }
output "cosmos_db_endpoint" { value = azurerm_cosmosdb_account.cosmos.endpoint }

# Output all created Web App default hostnames
output "web_app_hostnames" {
  value = { for k, v in azurerm_linux_web_app.microservices : k => "https://${v.default_hostname}" }
}