provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  region = "us-east-1"
  alias = "usa"
}

provider "okta" {}