variable "vpc_cidrs" {
  type = map(string)
  description = "CIDR blocks for VPCs in each region"
}

variable "public_subnet_cidrs" {
  type = map(list(string))
  description = "Public subnet CIDR blocks for each region"
}

variable "private_subnet_cidrs" {
  type = map(list(string))
  description = "Private subnet CIDR blocks for each region"
}

variable "availability_zones" {
  type = map(list(string))
  description = "Availability zones for each region"
}

variable "ami_ids" {
  type = map(string)
  description = "AMI IDs for ECS instances in each region"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type for ECS nodes"
}

variable "min_size" {
  type        = number
  default     = 2
  description = "Minimum size of the ECS cluster"
}

variable "max_size" {
  type        = number
  default     = 5
  description = "Maximum size of the ECS cluster"
}

variable "name_prefix" {
  type        = string
  default     = "romlab-ecsdemo"
  description = "Prefix for naming AWS resources"
}
