locals {
  my_ip = "157.51.19.112/32"
}

resource "aws_security_group" "jenkins_access" {
  name        = "jenkins_access"
  description = "Allow TLS inbound traffic for Jenkins instance"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description      = "HTTP from port 8080"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0", local.my_ip]
  }

  ingress {
    description      = "SSH from port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [local.my_ip]
  }

  egress {
    description      = "Egress to world"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_access"
  }
}
