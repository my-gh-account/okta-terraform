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


