include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/my-gh-account/infrastructure-modules//aws-services/terraform-vpc"

}

inputs = {
  aws_subnet1_az = "us-east-2a"
  incoming_cidr_blocks_ssh = ["0.0.0.0/0"]
  service_ports = [22, 443]
  vpc_cidr_block =  "10.0.0.0/16"
  subnet_cidr_block = "10.0.1.0/24"
}
