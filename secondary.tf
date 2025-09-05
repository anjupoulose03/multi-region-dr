# All secondary resources explicitly use the DR alias from providers.tf
# i.e., providers = { aws = aws.dr }

module "vpc_secondary" {
  source               = "./modules/vpc"
  providers            = { aws = aws.dr }
  name_prefix          = "secondary"
  vpc_cidr             = "10.1.0.0/16"
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.3.0/24"]
  azs                  = ["us-west-1a", "us-west-1b"]
}

module "ec2_secondary" {
  source        = "./modules/ec2"
  providers     = { aws = aws.dr }
  name_prefix   = "secondary"
  ami_id        = "ami-00271c85bf8a52b84"   # keeping your hard-coded AMI for us-west-1
  instance_type = "t3.micro"
  subnet_id     = module.vpc_secondary.public_subnet_ids[0]
  vpc_id        = module.vpc_secondary.vpc_id
  key_name      = "keypair-2"               # must exist in us-west-1
}

module "rds_secondary" {
  source           = "./modules/rds"
  providers        = { aws = aws.dr }
  name_prefix      = "secondary"
  db_name          = "prodapp"
  db_engine        = "mysql"
  instance_class   = "db.t3.micro"
  subnet_ids       = module.vpc_secondary.private_subnet_ids
  vpc_security_ids = [module.vpc_secondary.db_sg_id]
  multi_az         = false
  # username       = var.db_username   # uncomment if your module requires these
  # password       = var.db_password
}

module "s3_secondary" {
  source        = "./modules/s3"
  providers     = { aws = aws.dr }
  name_prefix   = "secondary"
  bucket_name = "project-secondary-bucket"
  # 'region' variable is optional; provider mapping above controls region
  region      = "us-west-1"
  
}

