output "website_url" {
  description = "URL of site"
  value = aws_s3_bucket_website_configuration.hosting_config.website_endpoint
}