terraform {
  backend "s3" {
    bucket         = "ij-tfstate"
    key            = "app.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "ij-tfstate-lock"
  }
}

provider "aws" {
  region = var.region
}

module "networking" {
  source = "./networking"
  cidr_block = "10.0.0.0/16" # Example value, ensure it matches your setup
}

module "security_groups" {
  source = "./security_groups"
  vpc_id = module.networking.vpc_id
}

module "load_balancer" {
  source = "./load_balancer"
  vpc_id            = module.networking.vpc_id
  subnet_ids         = module.networking.public_subnet_ids
  security_group_ids = [module.security_groups.elb_sg_id]

}

module "elastic_beanstalk" {
  source = "./elastic_beanstalk"
}

module "database" {
  source     = "./database"
  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids
}

module "celery_redis" {
  source = "./celery_redis"

  vpc_id            = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
}


module "monitoring" {
  source = "./monitoring"
}
