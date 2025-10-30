# --- Azure Resource Variables ---
variable "resource_group_name" {
  description = "Name for the Azure resource group."
  type        = string
}

variable "location" {
  description = "Azure region for deployment."
  type        = string
  default     = "Central India"
}

variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Basic"
}

variable "microservices" {
  description = "List of microservice names"
  type        = list(string)
  default     = ["api-gateway", "admin-service", "classroom-service", "discovery-server", "user-service", "ai-service"]
}

variable "app_service_plan_sku" {
  description = "App Service Plan SKU"
  type        = string
  default     = "F1"
}

variable "cosmos_db_kind" {
  description = "Cosmos DB kind"
  type        = string
  default     = "MongoDB"
}

# --- Azure DevOps + GitHub Variables ---
variable "azdo_org_service_url" {
  description = "Azure DevOps organization URL"
  type        = string
  default     = "https://dev.azure.com/reccloudcomputingproject"
}

variable "azdo_project_name" {
  description = "Azure DevOps Project Name"
  type        = string
  default     = "Mesh"
}

variable "github_repo_id" {
  description = "GitHub Repository ID"
  type        = string
  default     = "GopinathR20/Mesh-Microservices-CICD"
}

variable "github_branch_name" {
  description = "GitHub Branch Name"
  type        = string
  default     = "main"
}

variable "github_connection_id" {
  description = "GitHub Service Connection ID in Azure DevOps"
  type        = string
  default     = "github.com_GopinathR20"
}
