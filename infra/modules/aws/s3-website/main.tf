locals {
  defaultOriginId = "defaultOrigin"
}

resource "aws_cloudfront_origin_access_identity" "cf_id" {}

resource "aws_cloudfront_distribution" "website" {
  depends_on = [aws_acm_certificate_validation.validation]
  enabled = true
  aliases = [local.websiteDomain]
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.defaultOriginId
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    lambda_function_association {
      event_type = "viewer-request"
      lambda_arn = aws_lambda_function.auth.qualified_arn
    }
  }

  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = local.defaultOriginId
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cf_id.cloudfront_access_identity_path
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method = "sni-only"
  }

}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.cf_id.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [
      aws_s3_bucket.website_bucket.arn]

    principals {
      type        = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.cf_id.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.website_bucket_name
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}