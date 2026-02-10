variable "app_name" {
  type        = string
  description = "The name of the application or project"
}

variable "region" {
  type        = string
  description = "The region to create all associated resources"
}

variable "backend_bucket" {
  type        = string
  description = "The name of the bucket where terraform state files are persisted"
}

variable "secret_names" {
  type        = set(string)
  default     = []
  description = "A set of secret names to create in secret manager"
}

variable "repository_names" {
  type        = set(string)
  default     = []
  description = "A set of repository names to create in ECR"
}
