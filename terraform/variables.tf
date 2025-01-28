variable "tenant" {
  type        = string
  description = "Tenant name for resource naming"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "Central US"
}

variable "deploy_acr" {
  type    = bool
  default = false
}

variable "deploy_aks" {
  type    = bool
  default = false
}
