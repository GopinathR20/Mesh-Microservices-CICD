# infrastructure/variables.tf

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
  description = "The GitHub repository ID in the format 'username/repo'."
  type        = string
  default     = "GopinathR20/Mesh-Microservices-CICD" # <-- Updated
}

variable "github_branch_name" {
  description = "The name of the branch to use for pipelines."
  type        = string
  default     = "main" # <-- Updated
}

variable "github_connection_id" {
  description = "The name of the GitHub service connection in Azure DevOps."
  type        = string
  default     = "GitHub-OAuth-Connection" # Make sure this name is correct
}

variable "resource_group_name" {
  description = "The name of the Azure resource group."
  type        = string
  default     = "mesh-project-rg"
}

variable "location" {
  description = "The Azure region to deploy resources."
  type        = string
  default     = "Central India"
}

variable "acr_sku" {
  description = "The SKU for the Azure Container Registry."
  type        = string
  default     = "Basic"
}

variable "microservices" {
  description = "List of microservice names (must match folder names)."
  type        = list(string)
  default     = ["api-gateway", "admin-service", "classroom-service", "discovery-server", "user-service", "ai-service"]
}