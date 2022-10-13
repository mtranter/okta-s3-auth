terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.34"
      configuration_aliases = [
         aws,
         aws.usa,
       ]

    }
  }
}