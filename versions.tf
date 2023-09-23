terraform {
  required_version = ">=1.5.7"
  backend "s3" {
    bucket = "state-bucket-22092048"
    key = "terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    dynamodb_table = "state-bucket-lock-22092048"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17"
    }
    cloudinit = {
        source = "hashicorp/cloudinit"
        version = "~> 2.3"
    }
    random = {
        source = "hashicorp/random"
        version = "~> 3.5"
    }
  }
}