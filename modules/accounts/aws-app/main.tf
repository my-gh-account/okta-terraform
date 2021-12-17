terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}


#  data "terraform_remote_state" "policies" {
#  backend = "s3"
#
#  config = {
#    bucket = var.backend_s3_bucket
#    key    = "staging/accounts/aws-policies/terraform.tfstate"
#    region = var.backend_s3_bucket_region
#  }
#}




data "okta_groups" "okta_groups" {}
data "aws_caller_identity" "current" {}
data "aws_iam_policy" "valid_policies" {
  count = length(local.aws_group_names) 
  name = (element(split("-", local.aws_group_names[count.index]), 3))
}



locals {
 account_ids                   = [ data.aws_caller_identity.current.account_id ]
 aws_groups                    = [ for group in data.okta_groups.okta_groups.groups : group if ( length(regexall("(?i)aws", element(split("-", group.name), 1))) > 0) && contains(local.account_ids, element(split("-", group.name), 2))  ]
 aws_group_ids                 = local.aws_groups[*].id
 aws_group_names               = local.aws_groups[*].name
}


resource "aws_iam_saml_provider" "saml_provider" {
  name                   = var.saml_provider
  saml_metadata_document = okta_app_saml.aws_federation.metadata
  tags                   = {
     "Name"              = "okta sso saml provider"
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

resource "okta_app_saml" "aws_federation" {
  label             = "AWS Account Federation"
  preconfigured_app = "amazon_aws"
  lifecycle {
    ignore_changes = [users, groups]
  }
}

resource "okta_app_saml_app_settings" "aws_federation_settings" {
  app_id = okta_app_saml.aws_federation.id
  settings = jsonencode(
    {
      "appFilter" : "${var.app_filter}",
      "awsEnvironmentType" : "aws.amazon",
      "groupFilter" : "^app\\-aws\\-(?{{accountid}}\\d+)\\-(?{{role}}[\\w\\-]+)$"
      "joinAllRoles" : true,
      "loginURL" : "https://console.aws.amazon.com/ec2/home",
      "roleValuePattern" : "arn:aws:iam::$${accountid}:saml-provider/${var.saml_provider},arn:aws:iam::$${accountid}:role/$${role}",
      "sessionDuration" : 3600,
      "useGroupMapping" : true,
      "identityProviderArn" : "aws_iam_saml_provider.${var.saml_provider}.arn",
    }
  )
}

resource "okta_app_group_assignments" "AWSFederationGroups" {
  app_id = okta_app_saml.aws_federation.id

  for_each = toset(local.aws_group_ids)
  group {
    id = each.key
  }
}


resource "aws_iam_role" "okta-role" {
  count	              = length(data.aws_iam_policy.valid_policies)
  name                = data.aws_iam_policy.valid_policies[count.index].name
  assume_role_policy  = data.aws_iam_policy_document.instance-assume-role-policy.json
  managed_policy_arns = [data.aws_iam_policy.valid_policies[count.index].arn]
}


