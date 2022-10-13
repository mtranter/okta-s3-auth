variable "route53_zone_name" {
  type        = string
  description = "Your Route53 zone"
}

variable "subdomain" {
  type        = string
  description = "e.g. 'www'.. Will be prepended to the route53 zone name as the host for this website"
}

variable "okta_host" {
  type        = string
  description = "(optional) describe your variable"
}

variable "website_bucket_name" {
  type = string
}