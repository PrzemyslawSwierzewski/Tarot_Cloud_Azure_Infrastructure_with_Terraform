variable "tarot_cloud_rg_name" {
  type = string
}

variable "rg_location" {
  type        = string
  description = "The Azure region for the resources"
}

variable "postgres_subnet_id" {
  type        = string
  description = "The subnet ID where the PostgreSQL server will be deployed"
}

variable "postgresql_admin_password" {
  type        = string
  description = "The administrator password for the PostgreSQL server"
  sensitive   = true
}

variable "my_public_ip_address" {
  type        = string
  description = "The public IP address to allow access to the PostgreSQL server"
}

variable "private_dns_zone_id" {
  type        = string
  description = "The ID of the private DNS zone for PostgreSQL"
}