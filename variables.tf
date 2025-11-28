variable "ssh_public_key" {
  type        = string
  description = "Local SSH public key"
  sensitive   = true
}

variable "my_public_ip_address" {
  type        = string
  description = "Public IP address"
  sensitive   = true
}

variable "owner_email_address" {
  type        = string
  description = "Email address of the subscription owner"
}

variable "postgresql_admin_password" {
  type        = string
  description = "The password for the PostgreSQL administrator"
  sensitive   = true
}

variable "key_vault_name" {
  type        = string
  description = "The name of the Key Vault to be created"
  default = "kv-${local.prod_environment}-${random_string.kv_suffix.result}"
}