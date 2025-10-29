# infrastructure/variables.tf

variable "azdo_org_service_url" { default = "https://dev.azure.com/reccloudcomputingproject" }
variable "azdo_project_name" { default = "Mesh" }
variable "github_repo_id" { default = "GopinathR20/Mesh-Microservices-CICD" }
variable "github_branch_name" { default = "main" }
variable "github_connection_id" { default = "GitHub-OAuth-Connection" }
variable "resource_group_name" { default = "mesh-project-rg" }
variable "location" { default = "Central India" }
variable "acr_sku" { default = "Basic" }
variable "microservices" {
  description = "List of microservice names (must match folder names in 'services/')."
  type        = list(string)
  default     = ["api-gateway", "admin-service", "classroom-service", "discovery-server", "user-service", "ai-service"]
}
variable "app_service_plan_sku" {
  description = "SKU for the App Service Plan (F1=Free, B1=Basic)."
  type        = string
  default     = "F1" # Use F1 for Free tier (shared resources)
}
variable "cosmos_db_kind" {
  description = "Kind of Cosmos DB (GlobalDocumentDB or MongoDB)."
  default     = "GlobalDocumentDB" # Change to "MongoDB" if needed
}