module "network_us_east_2" {
  source = "./modules/network"
  providers = {
    aws = aws.us-east-2
  }

  romlab-ecsdemo-name_prefix  = var.name_prefix
  romlab-ecsdemo-vpc_cidr     = var.vpc_cidrs["us-east-2"]
  romlab-ecsdemo-public_cidrs = var.public_subnet_cidrs["us-east-2"]
  romlab-ecsdemo-priv_cidrs   = var.private_subnet_cidrs["us-east-2"]
  romlab-ecsdemo_azs          = var.availability_zones["us-east-2"]
  romlab-vpc_id               = module.network_us_east_2.vpc_id
  romlab-pub_subnet_ids       = module.network_us_east_2.public_subnet_ids
}

module "network_eu_west_1" {
  source = "./modules/network"
  providers = {
    aws = aws.eu-west-1
  }

  romlab-ecsdemo-name_prefix  = var.name_prefix
  romlab-ecsdemo-vpc_cidr     = var.vpc_cidrs["eu-west-1"]
  romlab-ecsdemo-public_cidrs = var.public_subnet_cidrs["eu-west-1"]
  romlab-ecsdemo-priv_cidrs   = var.private_subnet_cidrs["eu-west-1"]
  romlab-ecsdemo_azs          = var.availability_zones["eu-west-1"]
  romlab-vpc_id               = module.network_eu_west_1.vpc_id
  romlab-pub_subnet_ids       = module.network_eu_west_1.public_subnet_ids
}

module "ecs_us_east_2" {
  source = "./modules/ecs"
  providers = {
    aws = aws.us-east-2
  }

  romlab-ecsname_prefix     = var.name_prefix
  ami_id                    = var.ami_ids["us-east-2"]
  instance_type             = var.instance_type
  min_size                  = var.min_size
  max_size                  = var.max_size
  romlab-vpc_id             = module.network_us_east_2.vpc_id
  romlab-ecsdemo-priv_cidrs = module.network_us_east_2.private_subnet_ids
  subnet_ids                = module.network_us_east_2.private_subnet_ids
  lb_target_group_arn       = module.network_us_east_2.lb_target_group_arn_us
}

module "ecs_eu_west_1" {
  source = "./modules/ecs"
  providers = {
    aws = aws.eu-west-1
  }

  romlab-ecsname_prefix     = var.name_prefix
  ami_id                    = var.ami_ids["eu-west-1"]
  instance_type             = var.instance_type
  min_size                  = var.min_size
  max_size                  = var.max_size
  romlab-vpc_id             = module.network_eu_west_1.vpc_id
  romlab-ecsdemo-priv_cidrs = module.network_us_east_2.private_subnet_ids
  subnet_ids                = module.network_eu_west_1.private_subnet_ids
  lb_target_group_arn       = module.network_eu_west_1.lb_target_group_arn_eu
}

output "vpc_ids" {
  value = [module.network_us_east_2.vpc_id, module.network_eu_west_1.vpc_id]
}

output "private_subnet_ids" {
  value = {
    us-east-2 = module.network_us_east_2.private_subnet_ids
    eu-west-1 = module.network_eu_west_1.private_subnet_ids
  }
}
