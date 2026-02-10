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

variable "bundle_retention" {
  type        = number
  default     = 15
  description = "The number of days a product bundle should be retained in s3"
}

variable "distribution_domain" {
  type        = string
  description = "The domain registered with the cerificate to associate with the distribution"
}

variable "distribution_alias" {
  type        = set(string)
  default     = []
  description = "A set of aliases for the distribution"
}
