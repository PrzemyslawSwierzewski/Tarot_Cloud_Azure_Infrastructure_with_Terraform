variable "tarot_cloud_rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "subnets" {
  type        = list(string)
  description = "Map of subnet IDs to attach NSGs"
}

variable "vnets" {
  type = list(string)
}

variable "my_public_ip_address" {
  type = string
}