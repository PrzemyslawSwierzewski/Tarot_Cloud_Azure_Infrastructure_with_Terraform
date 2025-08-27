variable "tarot_cloud_rg_name" {
  type        = string
  description = "The name of the resource group where resources will be deployed"
} 

variable "rg_location" {
  type        = string
  description = "The Azure region where resources will be deployed"
}

variable "vm_identity" {
  type        = string
  description = "The identity of the virtual machine"
  sensitive   = true
}

variable "vm_id" {
  type        = string
  description = "The ID of the virtual machine"
  sensitive   = true
}

variable "storage_account_id" {
    type = string
}