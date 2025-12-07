module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins"

  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-06507cfe4e2b0eaf2"] #replace your SG
  subnet_id              = "subnet-0da0bf269651525a1" #replace your Subnet
  ami                    = data.aws_ami.ami_info.id
  associate_public_ip_address = true
  user_data              = file("jenkins.sh")

  tags = {
    Name = "jenkins"
  }
}

module "jenkins_agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-agent"

  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-06507cfe4e2b0eaf2"]
  # convert StringList to list and get first element
  subnet_id              = "subnet-0da0bf269651525a1"

  ami                    = data.aws_ami.ami_info.id
  associate_public_ip_address = true
  user_data              = file("jenkins-agent.sh")

  tags = {
    Name = "jenkins-agent"
  }
}

resource "aws_key_pair" "tools" {
  key_name   = "tools"
  # you can paste the public key directly like this
  #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINYRVVrsbcrwl/Q/3/98x+WaK4MHgRHfigg/Y8+MPzCI saiku@DESKTOP-JQEH3PL"
  public_key = file("~/.ssh/tools.pub")
  # ~ means windows home directory
}

module "nexus" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "nexus"

  instance_type          = "c7i-flex.large"
  vpc_security_group_ids = ["sg-06507cfe4e2b0eaf2"]
  # convert StringList to list and get first element
  subnet_id = "subnet-0da0bf269651525a1"
  ami = data.aws_ami.nexus_ami_info.id
  key_name = aws_key_pair.tools.key_name
  associate_public_ip_address = true
  root_block_device = {
      volume_type = "gp3"
      volume_size = 30
    }
  tags = {
    Name = "nexus"
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "jenkins-agent"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins_agent.private_ip
      ]
      allow_overwrite = true
    },
    {
      name    = "jenkins"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins.public_ip
      ]
      allow_overwrite = true
    },
    {
      name    = "nexus"
      type    = "A"
      ttl     = 1
      allow_overwrite = true
      records = [
        module.nexus.private_ip
      ]
      allow_overwrite = true
    }
  ]
}

