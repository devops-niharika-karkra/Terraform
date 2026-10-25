resource "aws_vpc" "wp-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name    = "wp-vpc"
    Project = var.project
    Owner   = var.owner

  }
}

resource "aws_subnet" "wp-subnet-public-1" {
  vpc_id                  = aws_vpc.wp-vpc.id
  cidr_block              = var.public_subnet_cidr_1
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "wp-subnet-public-1"
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_subnet" "wp-subnet-public-2" {
  vpc_id                  = aws_vpc.wp-vpc.id
  cidr_block              = var.public_subnet_cidr_2
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name    = "wp-subnet-public-2"
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_subnet" "wp-subnet-private" {
  vpc_id            = aws_vpc.wp-vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "us-east-1c"

  tags = {
    Name    = "wp-subnet"
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_internet_gateway" "wp-igw" {
  vpc_id = aws_vpc.wp-vpc.id

  tags = {
    Name    = "wp-igw"
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_nat_gateway" "wp-nat-gateway" {
  vpc_id            = aws_vpc.wp-vpc.id
  availability_mode = "regional"

  depends_on = [aws_internet_gateway.wp-igw]

  tags = {
    Name    = "wp-nat-gateway"
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_route_table" "wp-public-rt" {
  vpc_id = aws_vpc.wp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wp-igw.id
  }
  tags = {
    Name    = "wp-public-rt"
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_route_table_association" "wp-public-rt-assoc-1" {
  subnet_id      = aws_subnet.wp-subnet-public-1.id
  route_table_id = aws_route_table.wp-public-rt.id
}

resource "aws_route_table_association" "wp-public-rt-assoc-2" {
  subnet_id      = aws_subnet.wp-subnet-public-2.id
  route_table_id = aws_route_table.wp-public-rt.id
}

resource "aws_route_table" "wp-private-rt" {
  vpc_id = aws_vpc.wp-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.wp-nat-gateway.id
  }
  tags = {
    Name    = "wp-private-rt"
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_route_table_association" "wp-private-rt-assoc" {
  subnet_id      = aws_subnet.wp-subnet-private.id
  route_table_id = aws_route_table.wp-private-rt.id
}

