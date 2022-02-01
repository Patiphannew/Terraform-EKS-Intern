provider "aws" {
  profile = "produser"
  region  = "ap-southeast-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  # backend "s3" {
  #   bucket = "new-myawsbucket" # Bucket name
  #   key    = "./terraform.tfstate"
  #   region = "ap-southeast-1"
  #   #  # Enable State Locking
  #   #  dynamodb_table = "nopnithi-terraform-state-demo"
  #   profile = "produser"
  # }
}
