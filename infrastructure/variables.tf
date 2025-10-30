# --- Azure DevOps Auth ---
variable "azdo_org_service_url" {
  description = "Azure DevOps organization URL"
  type        = string
  default     = "https://dev.azure.com/reccloudcomputingproject"
}

# --- Azure SPN Auth (used in provider azurerm) ---
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
  default     = "MongoDB"
}

# --- GitHub + DevOps Project Vars ---
variable "azdo_project_name" {
  type        = string
  default     = "Mesh"
}

variable "github_repo_id" {
  type        = string
  default     = "GopinathR20/Mesh-Microservices-CICD"
}

variable "github_branch_name" {
  type        = string
  default     = "main"
}

variable "github_connection_id" {
  type        = string
  default     = "github.com_GopinathR20"
}
