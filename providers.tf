terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  alias = "us-east-2"
  default_tags {
    tags = {
        TimePeriod: "Dec2024"
        Project: "Terraform ECS Demo"
        Version: "1.0"
        Region: "US East"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  alias = "eu-west-1"
  default_tags {
    tags = {
      TimePeriod: "Dec2024"
      Project: "Terraform ECS Demo"
      Version: "1.0"
      Region: "EU West"
    }
  }
}