#create VPC
resource "aws_vpc" "dev" {
cidr_block = "10.0.0.0/16"
tags={
    Name = "dev"
}  
}
#create internet gateway and attach to vpc
resource "aws_internet_gateway" "dev" {
    vpc_id = aws_vpc.dev.id #IG attach block to vpc
  
}

#create subnets
resource "aws_subnet" "dev" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.dev.id #subnet attach block yo vpc
  
}


#cretae Route tables & attach internet gateway to Rt

resource "aws_route_table" "dev" {
    vpc_id = aws_vpc.dev.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev.id #attache block ig to rt
     
  }
  
}
#subent associations
resource "aws_route_table_association" "name" {
    route_table_id = aws_route_table.dev.id #rout table association rt attach
    subnet_id = aws_subnet.dev.id #rt association to subnet
  
}

# Security group

resource "aws_security_group" "dev" {
  name        = "allow_tls"
  vpc_id      = aws_vpc.dev.id
  tags = {
    Name = "dev_sg"
  }
 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }


egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }


  }
  


