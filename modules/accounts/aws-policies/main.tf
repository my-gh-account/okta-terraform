resource "aws_iam_policy" "policy" {
  for_each = { for policy in var.policies : policy.name => policy }

  name        = each.value.name
  path        = each.value.path != "" ? each.value.path :null
  description = each.value.description != "" ? each.value.description : null
  policy      = each.value.policy
  tags	      = length(each.value.tags) > 0 ? each.value.tags : {}
}
