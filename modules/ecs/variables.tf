variable "romlab-ecsname_prefix" {
  type = string
  default     = "romlab-ecsdemo"
}

variable "romlab-vpc_id" {
  type = string
}

variable "ami_id" {
  type    = string
}

variable "instance_type" {
  type    = string
}

variable "min_size" {
  type    = number
}

variable "max_size" {
  type    = number
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS tasks and services"
  type        = list(string)
}

variable "romlab-ecsdemo-priv_cidrs" {
  type    = list(string)
}

variable "lb_target_group_arn" {
  type = string
}