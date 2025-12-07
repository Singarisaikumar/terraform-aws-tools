
data "aws_ami" "ami_info" {
  most_recent      = true
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "nexus_ami_info" {

    most_recent = true
    owners = ["852699756283"]

    filter {
        name   = "name"
        values = ["redhat-nexus-*"]
    }
    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}


#ami-04c2c84ef7fc65ae4  kurian-nexus-repo-3.29.2-20250209-ubuntu-24.04-aa230897-
