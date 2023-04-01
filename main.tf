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
  region = var.aws_region
}

resource "aws_s3_bucket" "hosting" {
  bucket = var.site_bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

