output "vpc_id" {
  value = aws_vpc.romlab-main_vpc.id
}

output "private_subnet_ids" {
  description = "IDs of private subnets in the VPC"
  value       = aws_subnet.romlab-subnet-private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.romlab-subnet-public[*].id
}

output "lb_target_group_arn_us" {
  value = aws_lb_target_group.romlab-tg_us.arn
}

output "lb_target_group_arn_eu" {
  value = aws_lb_target_group.romlab-tg_eu.arn
}