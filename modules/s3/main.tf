terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # do NOT pin a version here; let the root control versions
    }
  }
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.name_prefix}-backup-bucket"

  tags = {
    Name = "${var.name_prefix}-bucket"
  }
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

locals {
  do_replication = (
    var.replication_arn != null && var.replication_arn != "" &&
    var.replication_role_arn != null && var.replication_role_arn != ""
  )
}

resource "aws_s3_bucket_replication_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  role   = "arn:aws:iam::654654409772:role/s3-replication-role" # Replace

  rule {
    id     = "replication-rule"
    status = "Enabled"

    filter {
      prefix = ""
    }

    destination {
      bucket        = arn:aws:s3:::project-secondary-bucket
      storage_class = "STANDARD"
    }
  }
}
