variable "ssh_public_key" {
  type        = string
  description = "Local SSH public key"
  default     = "${{ secrets.TF_API_TOKEN }}"
}