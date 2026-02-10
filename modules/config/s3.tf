// buckets for terraform state and application config files 
resource "aws_s3_bucket" "state_storage" {
  bucket = "${var.app_name}-state"
}

resource "aws_s3_bucket" "config_storage" {
  bucket = "${var.app_name}-config"
}

// it seemed appropriate to have these be versioned
resource "aws_s3_bucket_versioning" "state_storage_versioning" {
  bucket = aws_s3_bucket.state_storage.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "config_storage_versioning" {
  bucket = aws_s3_bucket.config_storage.id

  versioning_configuration {
    status = "Enabled"
  }
}
