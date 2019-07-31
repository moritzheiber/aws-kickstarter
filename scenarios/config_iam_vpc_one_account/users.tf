# This user is assigned to the group "admins" and therefore able to assume the role "resource-admin"
# It allows for full administrative access, including IAM and Organization permissions
#
# Notice how we are using a module output from the iam-users core module to assign the group membership
resource "aws_iam_user" "admin" {
  name = var.admin_name
}

resource "aws_iam_user_group_membership" "admin" {
  user = aws_iam_user.admin.name

  groups = [
    module.iam_users.admin_group_name,
  ]
}

# If you also wanted to assign a password and access key automatically, please take a look at the following
# resources:
# * https://www.terraform.io/docs/providers/aws/r/iam_user_login_profile.html
# * https://www.terraform.io/docs/providers/aws/r/iam_access_key.html

# This user is assigned to the group "users" and therefore able to assume the role "resource-user"
# These users have access to pretty much any service _except for_ IAM and Organization, to avoid unintended
# privilege escalation
#
# Notice how we are using a module output from the iam-users core module to assign the group membership
resource "aws_iam_user" "user" {
  name = var.user_name
}

resource "aws_iam_user_group_membership" "example1" {
  user = aws_iam_user.user.name

  groups = [
    module.iam_users.user_group_name
  ]
}

# If you also wanted to assign a password and access key automatically, please take a look at the following
# resources:
# * https://www.terraform.io/docs/providers/aws/r/iam_user_login_profile.html
# * https://www.terraform.io/docs/providers/aws/r/iam_access_key.html
