terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # do NOT pin a version here; let the root control versions
    }
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "rds" {
  identifier              = "${var.name_prefix}-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "mydb"
  username                = "admin"
  password                = "password123"  # Use secrets for production!
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.vpc_security_ids
  skip_final_snapshot     = true
}
