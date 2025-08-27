variable "tarot_cloud_rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "vm_id" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "owner_email_address" {
  type        = string
  description = "Email address of the subscription owner"
}

variable "vm_memory_bytes" {
  type        = number
  description = "Total prod VM memory in bytes (for memory alert threshold)"
  default     = 4000000000
}

variable "alert_severity_cpu" {
  type    = number
  default = 1
}

variable "alert_severity_memory" {
  type    = number
  default = 1
}