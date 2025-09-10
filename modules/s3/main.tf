terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version is controlled at root
    }
  }
}

locals {
  # Keep your naming, but make it globally unique by suffixing region
  bucket_name = "${var.name_prefix}-backup-bucket-${var.region}"
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name

  tags = merge(
    { Name = "${var.name_prefix}-bucket" },
    var.tags
  )
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Replication only when this is the SOURCE bucket (primary)
resource "aws_s3_bucket_replication_configuration" "this" {
  count  = var.enable_replication ? 1 : 0

  bucket = aws_s3_bucket.this.id
  role   = var.replication_role_arn

  rule {
    id     = "replicate-all"
    status = "Enabled"

    # explicitly state how to handle delete markers
    delete_marker_replication {
      status = "Enabled"   # or "Disabled" if you don't want delete markers replicated
    }

    filter { prefix = "" } # replicate everything

    destination {
      bucket        = var.replication_destination_bucket_arn # arn:aws:s3:::bucket-name
      storage_class = "STANDARD"
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.this,
    aws_s3_bucket_ownership_controls.this
  ]
}
