include "root" {
  path = find_in_parent_folders()
}

terraform {
#  source = "github.com/my-gh-account/infrastructure-modules//aws-policies"
   
  source = "../../../../modules.git//aws-policies"
}

inputs = {
#  aws_region  = aws_region
#  policies = policies
}
