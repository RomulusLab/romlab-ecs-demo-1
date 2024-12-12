# CIDR blocks for VPCs in each region
vpc_cidrs = {
  us-east-2 = "10.0.0.0/16"
  eu-west-1 = "10.1.0.0/16"
}

# Public subnet CIDR blocks for each region
public_subnet_cidrs = {
  us-east-2 = ["10.0.12.0/24", "10.0.21.0/24"]
  eu-west-1 = ["10.1.12.0/24", "10.1.21.0/24"]
}

# Private subnet CIDR blocks for each region
private_subnet_cidrs = {
  us-east-2 = ["10.0.123.0/24", "10.0.143.0/24"]
  eu-west-1 = ["10.1.123.0/24", "10.1.143.0/24"]
}

# Availability zones for each region
availability_zones = {
  us-east-2 = ["us-east-2a", "us-east-2b"]
  eu-west-1 = ["eu-west-1a", "eu-west-1b"]
}

# AMI IDs (Amazon Linux 2023) for ECS instances in each region
ami_ids = {
  us-east-2 = "ami-0c80e2b6ccb9ad6d1"
  eu-west-1 = "ami-02141377eee7defb9"
}
