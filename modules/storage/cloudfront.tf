// for convenience define origins as s3 buckts from ./s3.tf
locals {
  preview_origin_id = "${var.app_name}-preview"
  product_origin_id = "${var.app_name}-product"
}

// specify access for s3 buckets 
resource "aws_cloudfront_origin_access_control" "storage_access_control" {
  name                              = "${var.app_name}-access-control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

// define cloudfront distribution
resource "aws_cloudfront_distribution" "cdn_distribution" {
  enabled         = true
  is_ipv6_enabled = true
  web_acl_id      = data.aws_wafv2_web_acl.cdn_web_acl.arn

  origin {
    domain_name              = aws_s3_bucket.preview_storage.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.storage_access_control.id
    origin_id                = local.preview_origin_id
  }

  origin {
    domain_name              = aws_s3_bucket.product_storage.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.storage_access_control.id
    origin_id                = local.product_origin_id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" // Managed-CachingOptimized
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    target_origin_id       = local.preview_origin_id
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" // Managed-CachingOptimized
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "/bundles/*"
    target_origin_id       = local.product_origin_id
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cdn_certificate.arn
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  aliases = var.distribution_alias

  tags = {
    Name = "${var.app_name}-cdn"
  }
}
