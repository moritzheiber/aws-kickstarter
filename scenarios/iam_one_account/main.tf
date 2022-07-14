/**
* 
* This will create two groups, "admins" and "users" and let them assume the roles "resource-admin" or "resource-user" in the _same_ account, but with multi-factor authentication
* For more options you can set here please [refer to the module documentation](https://github.com/moritzheiber/terraform-aws-core-modules).
* 
*/

module "iam_users" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//iam-users"
}

module "iam_resources" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//iam-resources"
}
