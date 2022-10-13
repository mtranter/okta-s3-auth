terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.34"
    }
    okta = {
      source = "okta/okta"
      version = "~> 3.37"
    }
  }
}