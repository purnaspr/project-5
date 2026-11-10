resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_internet_gateway" "aig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "aig"
  }
}

resource "aws_route_table" "art" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aig.id
  }

  tags = {
    Name = "art"
  }
}

resource "aws_route_table_association" "arta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.art.id
}

resource "aws_security_group" "asg" {
  for_each = var.instance_config
  name     = "${each.key}-sg"
  vpc_id   = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = each.value.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.my_ip]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #my_ip
  }

  tags = {
    Name = "${each.key}-sg"
  }
}

resource "aws_instance" "project-5" {
  for_each                    = var.instance_config
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.asg[each.key].id]
  associate_public_ip_address = true
  root_block_device{
    volume_size =20
    volume_type ="gp3"
    delete_on_termination= true
    encrypted = true
  }

  tags = {
    Name = each.key
  }
}