locals {
  websiteDomain = "${var.subdomain}.${var.route53_zone_name}"
}

data "aws_route53_zone" "zone" {
  name = "${var.route53_zone_name}."
}

resource "aws_route53_record" "website" {
  provider = aws.usa
  name    = var.subdomain
  type    = "A"
  zone_id = data.aws_route53_zone.zone.id
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
  }
}

resource "aws_acm_certificate" "cert" {
  provider = aws.usa
  domain_name       = local.websiteDomain
  validation_method = "DNS"
}


resource "aws_route53_record" "record" {
  provider = aws.usa
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "validation" {
  provider = aws.usa
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]
}
