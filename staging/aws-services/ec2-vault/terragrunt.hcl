include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/my-gh-account/infrastructure-modules//ec2-instance"
}

inputs = {
  namespace = "Vault" 
  ami_owners = ["679593333241"]
  ami_name_search = ["hashicorp/marketplace/vault"]
  root_device_type = ["ebs"]
  virtualization_type = ["hvm"]
  instance_type = "t2.micro"
  vpc_id = dependency.public_vpc.outputs.external_vpc
  instance_subnet_id = dependency.public_vpc.outputs.external_subnet
  security_groups = [dependency.public_vpc.outputs.ssh_security_group]
  PUBLIC_KEY_PATH = "~/.ssh/id_rsa.pub"
  ami_id = "ami-047ef22376bb5ab32"
}

dependency "public_vpc" {
  config_path = "../public-vpc"
}
