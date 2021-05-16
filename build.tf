terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.40.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "worker" {
  ami           = "ami-08962a4068733a2b6"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "MyKeyPair"

  tags = {
    Role = "worker"

  }
}

resource "aws_instance" "web" {
  ami           = "ami-08962a4068733a2b6"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "MyKeyPair"

  tags = {
    Role = "web"
  }
}