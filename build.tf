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

  tags = {
    Role = "worker"
    Name = "worker"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-08962a4068733a2b6"
  instance_type = "t2.micro"

  tags = {
    Role = "web"
    Name = "web"
  }
}
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}

output "instance_web" {
  value = aws_instance.web.public_ip
}

output "instance_worker" {
  value = aws_instance.worker.public_ip
}

resource "null_resource" "ansible_hosts_provisioner" {
  depends_on = [time_sleep.wait_30_seconds]
  provisioner "local-exec" {
    interpreter = ["/bin/bash" ,"-c"]
    command = <<EOT
      export terraform_worcer_public_ip=$(terraform output instance_worker);
      echo $terraform_staging_public_ip;
      export terraform_web_public_ip=$(terraform output instance_web);
      echo $terraform_production_public_ip;
      sed -i -e "s/instance_worker/terraform_worker_public_ip/g" ./inventory/hosts;
      sed -i -e "s/instance_web/terraform_web_public_ip/g" ./inventory/hosts;
      sed -i -e 's/"//g' ./inventory/hosts;
      export ANSIBLE_HOST_KEY_CHECKING=False
    EOT
  }
}
