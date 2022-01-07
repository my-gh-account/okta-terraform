include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/my-gh-account/infrastructure-modules//aws-policies"
}

inputs = {
policies = [
    {
      name        = "test_policy"
      description = "a testing policy"
      path        = "/"
      tags = {
        name = "PatrickPolicy"
      }
      policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [{
          "Effect" : "Allow",
          "Action" : [
            "directconnect:Describe*",
            "directconnect:List*",
            "ec2:DescribeVpnGateways",
            "ec2:DescribeTransitGateways"
          ],
          "Resource" : "*"
        }]
      })
    },
    {
      name        = "test_policy2"
      description = "a testing policy"
      path        = "/"
      tags = {
        name = "PatrickPolicy2"
      }
      policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [{
          "Effect" : "Allow",
          "Action" : [
            "*"
          ],
          "Resource" : "*"
        }]
      })
    },
    {
      name        = "test_policy99"
      description = "a testing policy"
      path        = "/"
      tags = {
        name = "PatrickPolicy"
      }
      policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [{
          "Effect" : "Allow",
          "Action" : [
            "directconnect:Describe*",
            "directconnect:List*",
            "ec2:DescribeVpnGateways",
            "ec2:DescribeTransitGateways"
          ],
          "Resource" : "*"
        }]
      })
    },
    {
      name        = "test_policy3"
      description = "a testing policy"
      path        = "/"
      tags = {
        name = "PatrickPolicy"
      }
      policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [{
          "Effect" : "Allow",
          "Action" : [
            "directconnect:Describe*",
            "directconnect:List*",
            "ec2:DescribeVpnGateways",
            "ec2:DescribeTransitGateways"
          ],
          "Resource" : "*"
        }]
      })
    },
   ]
}
