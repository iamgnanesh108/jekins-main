provider "aws" {
}

locals {
  ingress_rules = [{
    port        = 443
    description = "Ingress rules for port 443"
    },
    {
      port        = 80
      description = "Ingree rules for port 80"
  },
  {
      port        = 8080
      description = "Ingree rules for port 8080"

  }]
}

resource "aws_instance" "ec2_example" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = {
    Name = "Terraform EC2"
  }
}

resource "aws_security_group" "main" {

  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "*"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
  }]

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = "*"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = "terra sg"
  }
}
