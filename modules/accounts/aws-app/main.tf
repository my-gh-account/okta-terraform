#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA PROVIDER VERSION REQUIREMENTS 
# Okta's resource requires you specify this version to work
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}





#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA GROUP AND AWS ACCOUNT NUMBER DATA SOURCES
# These pull down the existing groups configured in okta along with the aws account number
# This along with the  below local variables will  filter these groups with those designated for the aws app
#-------------------------------------------------------------------------------------------------------------------------------------


data "okta_groups" "okta_groups" {}
data "aws_caller_identity" "current" {}




#-------------------------------------------------------------------------------------------------------------------------------------
# LOCAL VARIABLES FOR AWS GROUP ID AND NAME - IAM POLICY DATA SOURCE
# This is used to filter out only the existing groups that had app-aws-account#-validpolicyarn in them for group-role mapping
# The local variables filters out the first two, and the valid_policies data source will cause the the apply to fail if
# one of the SSOs is valid, so it won't just accidentally assign a whole bunch of invalid/useless roles to AWS
#-------------------------------------------------------------------------------------------------------------------------------------

locals {
  account_ids     = [data.aws_caller_identity.current.account_id]
  aws_groups      = [for group in data.okta_groups.okta_groups.groups : group if(length(regexall("(?i)aws", element(split("-", group.name), 1))) > 0) && contains(local.account_ids, element(split("-", group.name), 2))]
  aws_group_ids   = local.aws_groups[*].id
  aws_group_names = local.aws_groups[*].name
}

data "aws_iam_policy" "valid_policies" {
  count = length(local.aws_group_names)
  name  = (element(split("-", local.aws_group_names[count.index]), 3))
}







#-------------------------------------------------------------------------------------------------------------------------------------
# TRUSTED IDENTITY PROVIDER FOR THE AWS GENERATED ROLES
# This is the created trusted identity to login that roles will be assigned to later when we generate them
# It gets its xml metadata from the aws app metadata data output
#-------------------------------------------------------------------------------------------------------------------------------------

resource "aws_iam_saml_provider" "saml_provider" {
  name                   = var.saml_provider
  saml_metadata_document = okta_app_saml.aws_federation.metadata 
  tags = {
    "Name" = "okta sso saml provider"
  }
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_saml_provider.saml_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "SAML:aud"

      values = [
        "https://signin.aws.amazon.com/saml"
      ]
    }
  }
}




#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA AWS FEDERATION APP
# This is the actual app users will use to sign on to AWS.  It will output a metadata xml file for the trusted identity provider
#-------------------------------------------------------------------------------------------------------------------------------------



resource "okta_app_saml" "aws_federation" {
  label             = "AWS Account Federation"
  preconfigured_app = "amazon_aws"
  lifecycle {
    ignore_changes = [users, groups]
  }
}


#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA AWS FEDERATION APP SETTINGS
#-------------------------------------------------------------------------------------------------------------------------------------

resource "okta_app_saml_app_settings" "aws_federation_settings" {
  app_id = okta_app_saml.aws_federation.id
  settings = jsonencode(
    {
      # AppFilter set by variable in variables.tf to restrict source of users
      "appFilter" : "${var.app_filter}",
      "awsEnvironmentType" : "aws.amazon",
      # Regex responsponsible for detecting group is meant to go to aws, with account ID, and mapped to the proper role
      "groupFilter" : "^app\\-aws\\-(?{{accountid}}\\d+)\\-(?{{role}}[\\w\\-]+)$"
      "joinAllRoles" : true,
      "loginURL" : "https://console.aws.amazon.com/ec2/home",
      "roleValuePattern" : "arn:aws:iam::$${accountid}:saml-provider/${var.saml_provider},arn:aws:iam::$${accountid}:role/$${role}",
      "sessionDuration" : 3600,
      # Use Group Mapping will make the above regex work, so groups are automatically assigned to Role at specified account
      "useGroupMapping" : true,
      "identityProviderArn" : "aws_iam_saml_provider.${var.saml_provider}.arn",
    }
  )
}




#-------------------------------------------------------------------------------------------------------------------------------------
# ASSIGNMENTS TO THE AWS APP
# This will assign group to the aws app, from the previously filtered out groups
#-------------------------------------------------------------------------------------------------------------------------------------

resource "okta_app_group_assignments" "AWSFederationGroups" {
  app_id = okta_app_saml.aws_federation.id

  for_each = toset(local.aws_group_ids)
  group {
    id = each.key
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------
# ROLE CREATION
# The automatic group to role matching is great, but wanted a way to also generate the role and mape it to a  policy so this wouldn't
# have to be managed in AWS. The Group mapping maps User to Role, but with this, we'll automatically generate the role name as well
# The Role will have the same name as the Policy it maps to.  If no policy exists, it will fail, you can use either an AWS Managed
# Policy, or a custom one (can specify the custom policy in aws-policies terraform module)
#-------------------------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "okta-role" {
  for_each             = { for policy in data.aws_iam_policy.valid_policies : policy.name => policy }
  name                 = each.value.name
  assume_role_policy   = data.aws_iam_policy_document.instance-assume-role-policy.json
  managed_policy_arns  = [each.value.arn]
  tags = {
    "Name"             = each.value.name
  }

}


