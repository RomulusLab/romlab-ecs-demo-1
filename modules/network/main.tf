resource "aws_vpc" "romlab-main_vpc" {
  cidr_block       = var.romlab-ecsdemo-vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.romlab-ecsdemo-name_prefix}-vpc"
  }
}

resource "aws_subnet" "romlab-subnet-public" {
  count           = length(var.romlab-ecsdemo-public_cidrs)
  vpc_id          = aws_vpc.romlab-main_vpc.id
  cidr_block      = var.romlab-ecsdemo-public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = element(var.romlab-ecsdemo_azs, count.index)
  tags = {
    Name = "${var.romlab-ecsdemo-name_prefix}-public-${count.index}"
  }
}

resource "aws_subnet" "romlab-subnet-private" {
  count           = length(var.romlab-ecsdemo-priv_cidrs)
  vpc_id          = aws_vpc.romlab-main_vpc.id
  cidr_block      = var.romlab-ecsdemo-priv_cidrs[count.index]
  availability_zone = element(var.romlab-ecsdemo_azs, count.index)
  tags = {
    Name = "${var.romlab-ecsdemo-name_prefix}-private-${count.index}"
  }
}

resource "aws_internet_gateway" "romlab-main_igw" {
  vpc_id = aws_vpc.romlab-main_vpc.id
  tags = {
    Name = "${var.romlab-ecsdemo-name_prefix}-igw"
  }
}

resource "aws_route_table" "romlab-public_rt" {
  vpc_id = aws_vpc.romlab-main_vpc.id
  tags = {
    Name = "${var.romlab-ecsdemo-name_prefix}-public-rt"
  }
}

resource "aws_route_table_association" "romlab-public_rtassoc" {
  count          = length(var.romlab-pub_subnet_ids)
  subnet_id      = var.romlab-pub_subnet_ids[count.index]
  route_table_id = aws_route_table.romlab-public_rt.id
}

resource "aws_route" "romlab-pub_subnet_route" {
  count                  = length(var.romlab-pub_subnet_ids)
  route_table_id         = aws_route_table.romlab-public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.romlab-main_igw.id
}


resource "aws_lb" "romlab-alb_main" {
  name               = "${var.romlab-ecsdemo-name_prefix}-alb"
  load_balancer_type = "application"
  subnets            = var.romlab-pub_subnet_ids
  security_groups    = [aws_security_group.romlab-main_sg.id]
  enable_deletion_protection = false

  tags = {
    Name = "${var.romlab-ecsdemo-name_prefix}-alb"
  }
}
resource "aws_lb_target_group" "romlab-tg_us" {
  name        = "${var.romlab-ecsdemo-name_prefix}-us-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.romlab-vpc_id
  target_type = "instance"
}

resource "aws_lb_target_group" "romlab-tg_eu" {
  name        = "${var.romlab-ecsdemo-name_prefix}-eu-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.romlab-vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.romlab-alb_main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Default response"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "lb_us_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1
  condition {
    path_pattern {
      values = ["/us*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.romlab-tg_us.arn
  }
}

resource "aws_lb_listener_rule" "lb_eu_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 2
  condition {
    path_pattern {
      values = ["/eu*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.romlab-tg_eu.arn
  }

}
resource "aws_security_group" "romlab-main_sg" {
  vpc_id = aws_vpc.romlab-main_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.romlab-ecsdemo-name_prefix}-alb-sg"
  }
}
