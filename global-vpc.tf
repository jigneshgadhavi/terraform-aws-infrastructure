resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Terraform VPC"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "Terraform IG"
  }
}

resource "aws_subnet" "main_vpc_subnet" {
  count             = 4
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.private_subnets_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "main_vpc_subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "main_vpc_public"
  }
}

resource "aws_route_table_association" "route_table_association" {
  count          = length(aws_subnet.main_vpc_subnet.*.id)
  subnet_id      = element(aws_subnet.main_vpc_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_vpc_peering_connection" "main_vpc_peering" {

  peer_vpc_id = "vpc-043c36080bc9dcd99"
  vpc_id      = aws_vpc.main_vpc.id
  auto_accept = true

  tags = {
    Name = "VPC Peering between main and default"
  }
}