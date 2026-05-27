terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
}

# Create a VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "terraform-vpc"
  }
}

# Create a Subnet
resource "aws_subnet" "terraform_subnet" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "172.16.10.0/24"

  tags = {
    Name = "terraform-subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "terraform_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-gateway"
  }
}

# Create a Route Table
resource "aws_route_table" "terraform_public_route" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_gateway.id
  }

  tags = {
    Name = "terraform-public-route"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "terraform_public_association" {
  subnet_id      = aws_subnet.terraform_subnet.id
  route_table_id = aws_route_table.terraform_public_route.id
}

# Create a Security Group
resource "aws_security_group" "terraform_security_group" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
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
    Name = "allow_ssh"
  }
}

# Add SSH Public Key
resource "aws_key_pair" "ssh_public_key" {
  key_name   = "gidii-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCy2+ngWQ2ub48qKMGrkd4oafkABbezCb+GYzZ2GvOD/CBIc0SbmeaunSOLsNNiJjCQ131kLF9Q2guo8enRxtdRqkGmYV4rhojuwqyNLIzoWxkaVAgahGqiEMlTRuKtRwX9Bme8Fk+Kfs+oTgZmo7XtWSNjswU8bUQK6g84k0fVmQ/+i6E+bk9jVd9oyc1kxmmLWwLEVXDhuNsRDp3JOtPsy97LPRTqcfF/Zy25I3mwWPVmeoj+pMekQaCYa1TqU9ZwCsf9o+hh3/hUtgojSMLgk0YRSCslq/H0T0tOKnIijzbIJYyJFy0wYdvAC07MWekWfLxGgyRhWrFdMNzdcdqGZVvS6DqqTK1H3BhMHhiyQn/l6gF8uMVETcf4Y4EaN4mW2ZhhuwQdvSS8hw9eMXOx8YRpzQN1wZvLid52jSIZxGY0XAIH9DFG27n/r3f9xdMAY6E6KQavy8Qp7jzIe8fiJffiizjb/I02u32Y+pUpDv9tdOyDyOiVcBxdR6lMVs2z6znriVWH1SRW+rUIaWusNT/K0pK3KOFu70zy1vhIH/t+WIIP62bSQyRAUoj6Ei5++2nKcIHTWtxRwUuNXln892q+QZgbliYqXYATOK31bc5JENtk4tRrfL/9QCOgm6paFwqGPWPoHFshpl7ZA23IT38KEbFQD9eh/ABcZLKrw== gedeon@Valentines-MacBook-Pro.local"
}

# Fetch the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Fetch the latest Ubuntu 24.04 Image
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "amazon-ec2-instance" {
  for_each = {
    debian = "ami-0b75f821522bcff85"
    rhel   = "ami-0d5e8769671b48387"
    ubuntu = "ami-05cf1e9f73fbad2e2"
  }

  ami           = each.value
  instance_type = "c7i-flex.large" # Free Tier eligible
  subnet_id     = aws_subnet.terraform_subnet.id
  key_name      = aws_key_pair.ssh_public_key.key_name
  region        = "us-east-1"
  vpc_security_group_ids = [
    aws_security_group.terraform_security_group.id
  ]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 40
    volume_type = "gp3"
  }

  tags = {
    Name = "terraform-${each.key}-instance"
  }
}

output "instance_ids" {
  value = {
    for name, instance in aws_instance.amazon-ec2-instance : name => instance.id
  }
}

output "public_ips" {
  value = {
    for name, instance in aws_instance.amazon-ec2-instance : name => instance.public_ip
  }
}

output "private_ips" {
  value = {
    for name, instance in aws_instance.amazon-ec2-instance : name => instance.private_ip
  }
}

