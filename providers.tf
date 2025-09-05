terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Primary
provider "aws" {
  region = "us-east-2"
}

# Secondary (DR)
provider "aws" {
  alias  = "dr"
  region = "us-west-1"
}
