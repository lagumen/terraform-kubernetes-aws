# Terraform Settings Block
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = ">= 4.65"
      version = "5.20.1"
    }
  }
}

# Terraform Provider Block
provider "aws" {
  region = var.aws_region
}