resource "aws_security_group" "romlab-ecs_sg" {
  name        = "romlab-ecsdemo-sg_name"
  description = "Security group for ECS cluster"
  vpc_id      =  var.romlab-vpc_id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["71.183.150.118/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "romlab-ecscluster-sg"
  }
}
resource "aws_ecs_cluster" "romlab-ecscluster_main" {
  name = "${var.romlab-ecsname_prefix}-ecscluster"
}

resource "aws_launch_template" "ecs" {
  name          = "${var.romlab-ecsname_prefix}-lc"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.romlab-ecscluster_main.name} >> /etc/ecs/ecs.config
yum update -y
amazon-linux-extras enable nginx
yum install -y nginx
systemctl start nginx
systemctl enable nginx
hostname=$(hostname)
echo "<html><body><h1>Welcome to ECS Node: $hostname</h1></body></html>" > /usr/share/nginx/html/index.html
EOF
  )

  network_interfaces {
    security_groups = [aws_security_group.romlab-ecs_sg.id]
    associate_public_ip_address = true
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "romlab-ecs_autoscale" {
  launch_template {
    id = aws_launch_template.ecs.id
    version = "$Latest"
  }
  min_size             = var.min_size
  max_size             = var.max_size
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "romlab-ecsdemo-autoscaling"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "romlab-ecs_autoscale_attach" {
  autoscaling_group_name = aws_autoscaling_group.romlab-ecs_autoscale.name
  lb_target_group_arn = var.lb_target_group_arn

}
