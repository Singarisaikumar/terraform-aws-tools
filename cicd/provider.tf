terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
        version = "6.16.0"
    }
  }
  backend "s3" {
    bucket       = "devopswithaws.store"
    key          = "jenkins"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}