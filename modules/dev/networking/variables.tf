variable "tarot_cloud_rg_name" {
  type        = string
  description = "The name of the resource group"
}

variable "rg_location" {
  type        = string
  description = "The Azure region for the resources"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev/prod)"
  default     = "development"
}

variable "vnet_name" {
  type        = string
  description = "Base name for the virtual network"
  default     = "tarot-cloud-network"
}

variable "subnet_name" {
  type        = string
  description = "Base name for the subnet"
  default     = "tarot-cloud-subnet"
}

variable "nic_name" {
  type        = string
  description = "Base name for the network interface"
  default     = "tarot-cloud-nic"
}

variable "public_ip_name" {
  type        = string
  description = "Base name for the public IP"
  default     = "tarot-cloud-public-ip"
}
