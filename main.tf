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

module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/web"
}

resource "aws_s3_bucket" "hosting" {
  bucket = var.site_bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "hosting_acl" {
  bucket = aws_s3_bucket.hosting.id
  acl = "public-read"
  
}

resource "aws_s3_bucket_policy" "hosting_policy" {
  bucket = aws_s3_bucket.hosting.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.site_bucket_name}/*"
            ]
        }
    ]
})
}

resource "aws_s3_bucket_website_configuration" "hosting_config" {
  bucket = aws_s3_bucket.hosting.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_object" "hosting_files" {
  bucket = aws_s3_bucket.hosting.id
  for_each = module.template_files.files
  key = each.key
  content_type = each.value.content_type

  source = each.value.source_path
  content = each.value.content

  etag = each.value.digests.md5
}