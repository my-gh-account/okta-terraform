terraform {
  backend "s3" {
    key = "staging/services/deployment-server/terraform.tfstate"
  }
}

provider "aws"{
  region = "us-east-2"
}

module "deployment-server" {
  source = "../../../modules/services/deployment-server/"
  cluster_name = "deployment-server-staging"
}

output "instance_ip" {
  description = "The public ip for ssh access"
  value       = module.deployment-server.instance_ip
}

