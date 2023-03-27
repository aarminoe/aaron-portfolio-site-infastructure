//When pushing to github run command (git filter-branch -f --index-filter 'git rm --cached -r --ignore-unmatch .terraform/')
//after you must run terraform init again in order for terraform apply to work

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-aaron-noe"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "my-other-test-bucket"
}

resource "aws_s3_bucket" "test" {
  bucket = "test-test"
}