# infrastructure/variables.tf

variable "resource_group_name" {
  description = "Name for the Azure resource group."
  type        = string
  default     = "mesh-project-rg"
}

variable "location" {
  description = "Azure region for deployment."
  type        = string
  default     = "Central India"
}

variable "microservices" {
  description = "List of microservice names (must match folder names)."
  type        = list(string)
  default     = ["api-gateway", "admin-service", "classroom-service", "discovery-server", "user-service", "ai-service"]
}

variable "app_service_plan_sku" {
  description = "SKU for the App Service Plan (F1=Free)."
  type        = string
  default     = "F1"
}

variable "cosmos_db_kind" {
  description = "Kind of Cosmos DB (GlobalDocumentDB or MongoDB)."
  default     = "MongoDB" # Set to MongoDB
}