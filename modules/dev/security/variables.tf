variable "tarot_cloud_rg_name" {
  type        = string
  description = "The name of the resource group"
}

variable "rg_location" {
  type        = string
  description = "The Azure region for the resources"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs to attach NSGs"
}

variable "vnets" {
  type        = list(string)
  description = "List of virtual network IDs"
}

variable "my_public_ip_address" {
  type        = string
  description = "Your public IP address for SSH access"
}

variable "nsg_name" {
  type        = string
  description = "Base name for the network security group"
  default     = "tarot-cloud-nsg"
}

variable "environment" {
  type        = string
  description = "Deployment environment (devprod)"
  default     = "development"
}