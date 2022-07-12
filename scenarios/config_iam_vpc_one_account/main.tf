module "config" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//config"
}

module "core_vpc" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//vpc"

  tags = var.tags
}

module "iam_users" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//iam-users"

  iam_users = var.iam_users
}

module "iam_resources" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//iam-resources"
}

# This is an example of a role restricting access for regular user accounts to any VPC API to avoid potential misconfiguration
# It's using one of the outputs from the iam-resources to assign the policy to the right role. Admin users will still be able to
# access VPC resources after having assumed the relevant role
resource "aws_iam_policy" "user_no_vpc_access_policy" {
  name        = "user_no_vpc_access_policy"
  description = "deny user access to VPC related commands"

  policy = data.aws_iam_policy_document.no_vpc_access_policy_document.json
}

resource "aws_iam_policy_attachment" "user_access_no_vpc_access_policy_attachment" {
  name       = "user_access_no_vpc_access_policy_attachment"
  roles      = [module.iam_resources.resource_user_role_name]
  policy_arn = aws_iam_policy.user_no_vpc_access_policy.arn
}
