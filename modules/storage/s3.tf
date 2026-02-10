// storage buckets:
// preview - compressed, processed preview images used in basic search
// product - full images and bundled zip files
resource "aws_s3_bucket" "preview_storage" {
  bucket = "${var.app_name}-preview"
}

resource "aws_s3_bucket" "product_storage" {
  bucket = "${var.app_name}-product"
}

// product bundles should be deleted after 15 days
resource "aws_s3_bucket_lifecycle_configuration" "product_storage_lifecycle" {
  bucket = aws_s3_bucket.product_storage.id

  rule {
    id     = "remove stale bundles"
    status = "Enabled"

    filter {
      prefix = "bundles/"
    }

    expiration {
      days = var.bundle_retention
    }
  }
}

// defining cloudfront access permission for buckets 
data "aws_iam_policy_document" "preview_policy" {
  statement {
    sid    = "PolicyForCloudFrontPrivateContent"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.preview_storage.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn_distribution.arn]
    }
  }
}

data "aws_iam_policy_document" "product_policy" {
  statement {
    sid    = "PolicyForCloudFrontPrivateContent"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.product_storage.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn_distribution.arn]
    }
  }
}

// attaching permissions to buckets
resource "aws_s3_bucket_policy" "preview_storage_policy" {
  bucket = aws_s3_bucket.preview_storage.bucket
  policy = data.aws_iam_policy_document.preview_policy.json
}

resource "aws_s3_bucket_policy" "product_storage_policy" {
  bucket = aws_s3_bucket.product_storage.bucket
  policy = data.aws_iam_policy_document.product_policy.json
}
