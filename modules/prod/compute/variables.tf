variable "vm_name" {
  type        = string
  description = "Base name for the virtual machine"
  default     = "tarot-cloud-vm"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev/prod)"
  default     = "Production"
}

variable "tarot_cloud_nic" {
  type        = list(string)
  description = "The network interface IDs for the virtual machines"
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
  default     = "" # Will be overridden in cloud environments
}

variable "type_handler_version" {
  type        = string
  description = "The version of the VM extension handler"
  default     = "1.13"
}
