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

variable "app_ingress_port" {
  type        = number
  default     = 8080
  description = "The main port the app server should accept traffic from"
}

variable "app_instane_type" {
  type        = string
  default     = "t3a.micro"
  description = "The instance type of application server ec2 instancesS"
}

variable "app_key_name" {
  type        = string
  description = "The name of the key attached to app ec2 instances"
}

variable "app_user_data_path" {
  type        = string
  description = "The path to the local user data bash script"
}

variable "app_domain" {
  type        = string
  description = "The domain associated with the application server"
}
