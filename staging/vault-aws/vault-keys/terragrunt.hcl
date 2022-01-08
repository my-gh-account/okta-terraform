include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/my-gh-account/infrastructure-modules//vault-prov"
}

inputs = {
  vault_address = dependency.ec2_vault.outputs.ec2_instance_ip
}

dependency "ec2_vault" {
  config_path = "../ec2-vault"
}
