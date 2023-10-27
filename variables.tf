# Provider configuration variables
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "container_count" {
  description = "Number of container to create"
  type        = number
  default     = 1
}
