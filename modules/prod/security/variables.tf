variable "nsg_name" {
  type        = string
  description = "Base name for the network security group"
  default     = "tarot-cloud-nsg"
}

variable "environment" {
  type        = string
  description = "Deployment environment (development/production)"
  default     = "Production"
}

variable "tarot_cloud_rg_name" {
  type        = string
  description = "Resource group name"
}

variable "rg_location" {
  type        = string
  description = "Azure region for the resources"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs to associate with the NSG"
}

variable "vnets" {
  type        = list(string)
  description = "List of VNet IDs (optional, for reference)"
}

variable "my_public_ip_address" {
  type        = string
  description = "Your public IP address for SSH access"
}