data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  jenkins_bootstrap = <<EOF
#!/bin/sh
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update -y
sudo apt-get install openjdk-8-jdk -y
sudo apt-get install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
EOF

  key_name = "personal-keypair"
  instance_type = "t2.micro"
}

resource "aws_instance" "jenkins_instance" {
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = local.jenkins_subnet
  instance_type = local.instance_type
  user_data     = local.jenkins_bootstrap
  key_name      = local.key_name

  iam_instance_profile = aws_iam_instance_profile.jenkins.id

  vpc_security_group_ids = [aws_security_group.jenkins_access.id]

  root_block_device {
    volume_size = 30
  }

  tags          = {
    Name       = "rahul-jenkins"
    created_by = "rahulp"
  }
}
