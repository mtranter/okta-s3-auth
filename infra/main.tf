locals {
  callback_path = "/__callback"
}

module "okta_auth_app" {
  source        = "./modules/okta/oidc-app"
  site_domain   = "${var.subdomain}.${var.route53_zone_name}"
  app_label     = "OAuth Demo"
  callback_path = local.callback_path
}

module "website" {
  source                      = "./modules/aws/s3-website"
  route53_zone_name           = var.route53_zone_name
  subdomain                   = var.subdomain
  oidc_provider_host          = var.okta_host
  oidc_provider_client_id     = module.okta_auth_app.okta_app.client_id
  oidc_provider_client_secret = module.okta_auth_app.okta_app.client_secret
  website_bucket_name         = var.website_bucket_name
  callback_path               = local.callback_path
  providers = {
    aws = aws
    aws.usa = aws.usa
   }
}
