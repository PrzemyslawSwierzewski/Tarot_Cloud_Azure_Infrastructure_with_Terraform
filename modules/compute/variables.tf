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
  description = "ssh_public_key from HCP terraform cloud"
  default     = "" # if env is cloud it will override it
}

variable "env" {
  type        = string
  description = "Environment type"
  default     = "local" # local or cloud, if runned in cloud it will override it
}
