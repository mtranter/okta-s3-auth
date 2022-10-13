output "website_bucket_name" {
    value = var.website_bucket_name
}

output "website_url" {
    value = "https://${var.subdomain}.${var.route53_zone_name}"
}

output "cf_distro_id" {
    value = module.website.cf_distro.id
}