locals {
  redirect_urls = [for u in concat([var.site_domain], var.cnames) : "https://${u}${var.callback_path}"]
}

resource "okta_app_oauth" "app" {
  label       = "${var.app_label}"
  type        = "web"
  grant_types = ["authorization_code"]
  client_uri  = "https://${var.site_domain}"
  logo_uri    = var.app_logo
  redirect_uris  = local.redirect_urls

  response_types = [
    "code"]

  lifecycle {
    ignore_changes = [
      users]
  }

}