include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/my-gh-account/infrastructure-modules//terraform-vpc"
}

inputs = {
  aws_region = "us-east-2"
  aws_subnet1_az = "us-east-2a"
  incoming_cidr_blocks_ssh = ["68.190.0.0/16"]
  service_ports = [22, 8200]
}
