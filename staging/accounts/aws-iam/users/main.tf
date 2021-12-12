terraform {
  backend "s3" {
    key            = "staging/accounts/aws-iam/users/terraform.tfstate"
  }
}

provider "aws" {
	region = "us-east-2"
}

#############Security Group##############

resource "aws_iam_group" "security-team" {
  name = "security-team"
  path = "/users/"
}

resource "aws_iam_group_membership" "security-team" {
  name = "security-team"

  users = [
	aws_iam_user.UserOne.name,
	aws_iam_user.UserTwo.name,
  ]

  group = aws_iam_group.security-team.name
}

resource "aws_iam_group_policy" "my_developer_policy" {
  name  = "my_developer_policy"
  group = aws_iam_group.my_developers.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
	   	"iam:*",
           	"organizations:DescribeAccount",
		"organizations:DescribeOrganization",
		"organizations:DescribeOrganizationalUnit",
		"organizations:DescribePolicy",
		"organizations:ListChildren",
		"organizations:ListParents",
		"organizations:ListPoliciesForTarget",
		"organizations:ListRoots",
		"organizations:ListPolicies",
		"organizations:ListTargetsForPolicy"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

##############Developers Group###############


resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}

resource "aws_iam_group_membership" "developers" {
  name = "developers"

  users = [
	aws_iam_user.UserThree.name,
	aws_iam_user.UserFour.name,
	aws_iam_user.UserFive.name,
  ]

  group = aws_iam_group.developers.name
}



resource "aws_iam_group_policy" "developers_policy" {
  name  = "developers_policy"
  group = aws_iam_group.developers.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}





##############User Configuration################



resource "aws_iam_user" "UserOne" {
  name = "UserOne"
  path = "/users/"
}

resource "aws_iam_user" "UserTwo" {
  name = "UserTwo"
  path = "/users/"
}

resource "aws_iam_user" "UserThree" {
  name = "UserThree"
  path = "/users/"
}

resource "aws_iam_user" "UserFour" {
  name = "UserFour"
  path = "/users/"
}

resource "aws_iam_user" "UserFive" {
  name = "UserFive"
  path = "/users/"
}


