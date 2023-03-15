provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAUGRI3PDAJK7DR5WP"
  secret_key = "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"
}

resource "aws_vpc" "test_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "test"
  }
}
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf"
  }
}
resource "aws_security_group" "cw_sg_ssh" {
  name = "test-sg"

  #Incoming traffic
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["172.16.10.0/24"] #replace it with your ip address
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["172.16.10.0/24"] #replace it with your ip address
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["172.16.10.0/24"] #replace it with your ip address
  }
}

resource "aws_key_pair" "my_blog_key" {
  key_name = "test_key"
  public_key = file("./ssh-keys/test.pub")
}
resource "aws_instance" "test-instance" {
  ami = "ami-0fc841be1f929d7d1"
  instance_type = "t2.micro"
  key_name = aws_key_pair.my_blog_key.key_name
  security_groups = ["test-sg"]
}
  
