# Primary VPC Module
module "vpc_primary" {
  source               = "./modules/vpc"
  name_prefix          = "primary"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24"]
  azs                  = ["us-east-2a", "us-east-2b"]
}

# EC2 Instance in Primary Region
module "ec2_primary" {
  source        = "./modules/ec2"
  name_prefix   = "primary"
  ami_id        = "ami-0cfde0ea8edd312d4"
  instance_type = "t2.micro"
  subnet_id     = module.vpc_primary.public_subnet_ids[0]
  vpc_id        = module.vpc_primary.vpc_id
  key_name      = "aws_key"  # Replace with your actual key pair name
}

# RDS Database in Primary Region
module "rds" {
  source           = "./modules/rds"
  name_prefix      = "primary"
  db_name          = "prodapp"
  db_engine        = "mysql"
  instance_class   = "db.t3.micro"
  subnet_ids       = module.vpc_primary.private_subnet_ids
  vpc_security_ids = [module.vpc_primary.db_sg_id]
  multi_az         = true
}

# S3 with Cross-Region Replication
module "s3" {
  source          = "./modules/s3"
  name_prefix     = "primary"
  bucket_name     = "project-primary-bucket"
  replication_arn = "arn:aws:s3:::project-secondary-bucket"
  region          = "us-east-2"
  replication_role_arn = "arn:aws:iam::334712111310:role/s3-replicationrole"  # Replace with valid IAM role ARN
}

# Route53 DNS Failover
module "route53" {
  source        = "./modules/route"
  zone_id       = "Z00755303QERKHRLHU1G4"            # Replace with your hosted zone ID
  record_name   = "drtest.online"
  primary_ip    = module.ec2_primary.public_ip
  secondary_ip  = module.ec2_secondary.public_ip  # Make sure module.ec2_secondary is defined
}
