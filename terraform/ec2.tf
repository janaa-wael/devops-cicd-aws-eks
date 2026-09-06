data "aws_ami" "ubuntu_2404" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_key_pair" "jenkins" {
  key_name   = "devops-jenkins"
  public_key = file(pathexpand(var.jenkins_public_key_path))

  tags = {
    Name    = "devops-jenkins"
    Project = var.project_name
  }
}

resource "aws_security_group" "jenkins" {
  name        = "devops-jenkins-sg"
  description = "Controls administrator access to the Jenkins EC2 instance."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name    = "devops-jenkins-sg"
    Project = var.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_ssh" {
  security_group_id = aws_security_group.jenkins.id
  description       = "SSH access from the administrator IPv4 address."
  cidr_ipv4         = var.allowed_admin_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_web" {
  security_group_id = aws_security_group.jenkins.id
  description       = "Jenkins web access from the administrator IPv4 address."
  cidr_ipv4         = var.allowed_admin_cidr
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "jenkins_all_ipv4" {
  security_group_id = aws_security_group.jenkins.id
  description       = "Allow outbound IPv4 internet access for package downloads."
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.ubuntu_2404.id
  instance_type               = var.jenkins_instance_type
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.jenkins.id]
  key_name                    = aws_key_pair.jenkins.key_name
  associate_public_ip_address = true

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 20
    volume_type           = "gp3"
  }

  tags = {
    Name    = "devops-jenkins"
    Project = var.project_name
  }
}
