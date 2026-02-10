// this is disabled, but "Distributions with a pricing plan subscription must have a web ACL resource." - aws
data "aws_wafv2_web_acl" "cdn_web_acl" {
  name   = "CreatedByCloudFront-54d1a3c2"
  scope  = "CLOUDFRONT"
  region = "us-east-1" // required when "CLOUDFRONT" is the value for scope
}

// needed cloudfront aliases to work
data "aws_acm_certificate" "cdn_certificate" {
  region   = "us-east-1" // must be in this region to be used with cloudfront
  domain   = var.distribution_domain
  statuses = ["ISSUED"]
}
