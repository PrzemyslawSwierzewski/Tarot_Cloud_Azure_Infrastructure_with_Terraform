variable "tarot_cloud_rg_name" {
  type        = string
  description = "The name of the resource group"
}

variable "rg_location" {
  type        = string
  description = "The Azure region for the resources"
}

variable "postgresql_admin_password" {
  type        = string
  description = "The administrator password for the PostgreSQL server"
  sensitive   = true
}

variable "vmss_identity_object_id" {
  type        = string
  description = "The object ID of the VMSS managed identity."
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev/prod)"
  default     = "production"
}