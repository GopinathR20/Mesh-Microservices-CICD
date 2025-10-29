# infrastructure/variables.tf

# --- Azure DevOps & GitHub Variables ---

variable "azdo_org_service_url" {
  description = "The URL of the Azure DevOps organization."
  type        = string
  default     = "https://dev.azure.com/reccloudcomputingproject"
}

variable "azdo_project_name" {
  description = "The name of the Azure DevOps project."
  type        = string
  default     = "Mesh"
}

variable "github_repo_id" {
  description = "The GitHub repository ID (e.g., 'username/repo')."
  type        = string
  default     = "GopinathR20/Mesh-Microservices-CICD" # Your CICD Repo
}

variable "github_branch_name" {
  description = "The branch pipelines will monitor."
  type        = string
  default     = "main" # Your main branch
}

variable "github_connection_id" {
  description = "Name of the GitHub service connection in Azure DevOps."
  type        = string
  default     = "github.com_GopinathR20" # Your verified connection name
}

# --- Azure Resource Variables ---

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

variable "acr_sku" {
  description = "SKU for Azure Container Registry (Basic includes free tier)."
  type        = string
  default     = "Basic"
}

variable "microservices" {
  description = "List of microservice names (must match folder names in 'services/')."
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