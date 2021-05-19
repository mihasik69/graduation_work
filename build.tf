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

  }
}

resource "aws_instance" "web" {
  ami           = "ami-08962a4068733a2b6"
  instance_type = "t2.micro"

  tags = {
    Role = "web"
  }
}
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}

resource "null_resource" "ansible_hosts_provisioner" {
  depends_on = [time_sleep.wait_30_seconds]
  provisioner "local-exec" {
    interpreter = ["/bin/bash" ,"-c"]
    command = <<EOT
      export terraform_worker_public_ip=$(terraform output public_iansiblep.worker);
      echo $terraform_worker_public_ip;
      export terraform_web_public_ip=$(terraform output web_public_ip);
      echo $terraform_web_public_ip;
      sed -i -e "s/staging_instance_ip/$terraform_staging_public_ip/g" ./inventory/hosts;
      sed -i -e 's/"//g' ./inventory/hosts;
      export ANSIBLE_HOST_KEY_CHECKING=False
    EOT
  }
}

output "instance_ips" {
  value = aws_instance.web.*.public_ip
}