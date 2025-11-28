variable "vm_name" {
  type        = string
  description = "Base name for the virtual machine"
  default     = "tarot-cloud-vmss"
}

variable "tarot_cloud_rg_name" {
  type        = string
  description = "The name of the resource group"
}

variable "rg_location" {
  type        = string
  description = "The Azure region for the resources"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the virtual machine"
  default     = "prem"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for the virtual machine"
  default     = "" # This is being pulled from github secrets in the root module
}

variable "type_handler_version" {
  type        = string
  description = "The version of the VM extension handler"
  default     = "1.38"
}

variable "vmss_subnet_id" {
  type        = string
  description = "The subnet IDs for the virtual machines"
}

variable "backend_pool_ids" {
  type        = list(string)
  description = "The backend address pool IDs for the load balancer"
}

variable "owner_email_address" {
  type        = string
  description = "Email address of the subscription owner"
}

variable "key_vault_name" {
  type        = string
  description = "The name of the Key Vault to fetch secrets from."
}