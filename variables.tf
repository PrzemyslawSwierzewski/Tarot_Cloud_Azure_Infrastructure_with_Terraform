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