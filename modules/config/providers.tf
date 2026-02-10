terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.25.0"
    }
  }

  backend "s3" {
    region = var.region
    bucket = var.backend_bucket
    key    = "config/terraform.tfstate"
  }

  required_version = ">= 1.14"
}

provider "aws" {
  region = var.region
}
