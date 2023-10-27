# VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc"
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id
}

# NAT Gateway
resource "aws_nat_gateway" "ngw" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat.id

  depends_on = [aws_internet_gateway.igw]
}

# Security groups
resource "aws_security_group" "http" {
  name        = "http"
  description = "HTTP traffic from anywhere"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  name        = "ecs"
  description = "Traffic from Load Balancer"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    security_groups = [aws_security_group.http.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
