variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret"
  type        = string
  sensitive   = true
}

variable "ssh_key_name" {
  description = "SSH key pair"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Allowed CIDR block for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}
