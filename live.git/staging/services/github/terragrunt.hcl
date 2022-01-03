include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/my-gh-account/infrastructure-modules//github"
}

inputs = {
  github_repo = "okta-terraform"
}


