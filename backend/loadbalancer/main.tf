data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

}

resource "aws_subnet" "az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_security_group" "lb_sg" {
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "allow_all" {
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 8080
    protocol         = "TCP"
    security_groups = [aws_security_group.lb_sg.id]
  }
  vpc_id = aws_vpc.main.id
}

resource "aws_lb" "app_loadbalancer" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  subnets = [aws_subnet.az1.id, aws_subnet.az2.id]
  enable_deletion_protection = false
  security_groups = [aws_security_group.lb_sg.id]
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.az1.id, aws_subnet.az2.id]
  security_group_ids = [aws_security_group.allow_all.id]
}
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.az1.id, aws_subnet.az2.id]
  security_group_ids = [aws_security_group.allow_all.id]
}
resource "aws_vpc_endpoint" "secrets" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.az1.id, aws_subnet.az2.id]
  security_group_ids = [aws_security_group.allow_all.id]
}
