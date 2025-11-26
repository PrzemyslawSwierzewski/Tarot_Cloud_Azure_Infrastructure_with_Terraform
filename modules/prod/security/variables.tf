variable "nsg_name" {
  type        = string
  description = "Base name for the network security group"
  default     = "tarot-cloud-nsg"
}

variable "environment" {
  type        = string
  description = "Deployment environment (development/production)"
  default     = "production"
}

variable "tarot_cloud_rg_name" {
  type        = string
  description = "Resource group name"
}

variable "rg_location" {
  type        = string
  description = "Azure region for the resources"
}

variable "vmss_subnet_id" {
  type        = string
  description = "List of subnet IDs to associate with the NSG"
}

variable "my_public_ip_address" {
  type        = string
  description = "Your public IP address for SSH access"
}