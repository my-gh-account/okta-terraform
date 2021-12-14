terraform {
  backend "s3" {
    key            = "staging/accounts/okta/apps/terraform.tfstate"
  }
}

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}


provider "aws" {
	region = "us-east-2"
}

data "terraform_remote_state" "aws_group_memberships" {
  backend = "s3"

  config = {
    bucket = "terraform-okta-backend-pputman"
    region = "us-east-2"
    key    = "staging/accounts/okta/users/terraform.tfstate"
  }
}
 



resource "aws_iam_saml_provider" "okta_sso" {
    name                   = "OktaSSO"
    saml_metadata_document = okta_app_saml.aws_federation.metadata
}



resource "okta_app_saml" "aws_federation" {
	label	= "AWS Account Federation"
	preconfigured_app = "amazon_aws"
	lifecycle {	
          ignore_changes = [users]
	}
}


resource "okta_app_saml_app_settings" "aws_federation_settings" {
	app_id = okta_app_saml.aws_federation.id
	settings = jsonencode(
		  {
		    "appFilter" : "okta",
		    "awsEnvironmentType" : "aws.amazon",
		    "groupFilter" : "^aws\\#\\S+\\#(?{{role}}[\\w\\-]+)\\#(?{{accountid}}\\d+)$"
		    "joinAllRoles" : true,
		    "loginURL" : "https://console.aws.amazon.com/ec2/home",
		    "roleValuePattern" : "arn:aws:iam::$${accountid}:saml-provider/OktaSSO,arn:aws:iam::$${accountid}:role/$${role}",
		    "sessionDuration" : 3600,
		    "useGroupMapping" : true,
		    "identityProviderArn" : aws_iam_saml_provider.okta_sso.arn,
		  }
  	)
}


resource "okta_app_group_assignments" "AWSFederationGroups" {
  app_id   = okta_app_saml.aws_federation.id
    group {
     
    id = data.terraform_remote_state.aws_group_memberships.outputs.AWSFullAccessMembership
    priority = 1
  }
  group {
    id = data.terraform_remote_state.aws_group_memberships.outputs.S3FullMembership
    priority = 2
  }
}


