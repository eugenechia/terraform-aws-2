resource "aws_vpc" "gene_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "TF-VM"
  }
}

resource "aws_subnet" "gene_public_subnet" {
  vpc_id                  = aws_vpc.gene_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "gene_gw" {
  vpc_id = aws_vpc.gene_vpc.id

  tags = {
    Name = "dev-ig"
  }
}

resource "aws_route_table" "gene_public_rt" {
  vpc_id = aws_vpc.gene_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.gene_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gene_gw.id
}

resource "aws_route_table_association" "gene_public_assoc" {
  subnet_id      = aws_subnet.gene_public_subnet.id
  route_table_id = aws_route_table.gene_public_rt.id
}

resource "aws_security_group" "gene_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.gene_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "gene_auth" {
  key_name   = "homelabkey"
  public_key = file("~/.ssh/AWS_TF_gene.pub")
}

resource "aws_instance" "dev_node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.gene_auth.id
  vpc_security_group_ids = [aws_security_group.gene_sg.id]
  subnet_id              = aws_subnet.gene_public_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "eugene-tf-vm"
  }




}