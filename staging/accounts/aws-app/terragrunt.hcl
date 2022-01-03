include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/my-gh-account/infrastructure-modules//aws-app"
}

dependencies {
  paths = ["../okta-users", "../okta-groups", "../aws-policies"]
}

inputs = {
  app_name  = "aws"
  app_display_name  = "AWS"
  aws_saml_provider_name = "Okta-SSO"
  aws_saml_app_filter = "okta"
  accounts = {
    "975678609170" = {
      app_links_json = {
        login     = true
      },
    },
  }
}
