terraform {
  backend "s3" {
    key = "staging/services/deployment-server/terraform.tfstate"
  }
}

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}
provider "aws"{
  region = "us-east-2"
}

module "deployment-server" {
  source = "../../../modules/services/deployment-server/"
  cluster_name = "deployment-server-staging"
}

