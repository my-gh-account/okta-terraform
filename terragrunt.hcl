# stage/terragrunt.hcl
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "terraform-okta-backend-pputman"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-okta-backend-pputman"
  }
}
terraform {
extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=${get_terragrunt_dir()}/../../../common.tfvars",
      "-var-file=${get_terragrunt_dir()}/../../region.tfvars",
    ]
  }
}
