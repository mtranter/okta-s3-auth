output "cf_distro" {
  value = aws_cloudfront_distribution.website
}

output "website_fqdn" {
  value = aws_route53_record.website.fqdn
}

output "website_bucket" {
  value = aws_s3_bucket.website_bucket
}