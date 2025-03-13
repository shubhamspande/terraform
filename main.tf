resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# DMZ (Public) Subnet
resource "aws_subnet" "dmz" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dmz_subnet_cidr
  availability_zone       = "us-west-2a"  # Modify as per your region's availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "DMZ Subnet"
  }
}

# Web (Private) Subnet
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnet_cidr
  availability_zone = "us-west-2a"
  tags = {
    Name = "Web Subnet"
  }
}

# App (Private) Subnet
resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_cidr
  availability_zone = "us-west-2a"
  tags = {
    Name = "App Subnet"
  }
}

# Database (Private) Subnet
resource "aws_subnet" "db" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidr
  availability_zone = "us-west-2a"
  tags = {
    Name = "DB Subnet"
  }
}

# Internet Gateway (for Public Subnet - DMZ)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# NAT Gateway (for Private Subnets)
resource "aws_eip" "nat" {
  domain = "vpc"  # Use 'domain' instead of 'vpc'
  instance = aws_instance.example.id
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.dmz.id
}

# Route Table for Private Subnets (using NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Associate Private Subnets with the Route Table
resource "aws_route_table_association" "web_association" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "app_association" {
  subnet_id      = aws_subnet.app.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db_association" {
  subnet_id      = aws_subnet.db.id
  route_table_id = aws_route_table.private.id
}

# EC2 Instance in the Web Subnet
resource "aws_instance" "web_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.web.id
  private_ip    = "10.0.2.10"  # Specific private IP for the Web instance
  tags = {
    Name = "Web_Instance"
  }

  metadata_options {
    http_tokens = "required"  # Enable IMDV2
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
}

