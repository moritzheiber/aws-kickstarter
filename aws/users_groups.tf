# Users
resource "aws_iam_user" "admin" {
  name          = "admin"
  force_destroy = true
}

resource "aws_iam_user" "user" {
  name          = "user"
  force_destroy = true
}

# Groups
resource "aws_iam_group" "admins" {
  name = "Admins"
}

resource "aws_iam_group" "developer" {
  name = "Developer"
}

# Group memberships
resource "aws_iam_group_membership" "admins_members" {
  name = "Administrators"

  users = [
    "${aws_iam_user.admin.name}",
  ]

  group = "${aws_iam_group.admins.name}"
}

resource "aws_iam_group_membership" "developer_members" {
  name = "Developers"

  users = [
    "${aws_iam_user.admin.name}",
    "${aws_iam_user.user.name}",
  ]

  group = "${aws_iam_group.developer.name}"
}

# Group policy assignments
resource "aws_iam_policy_attachment" "developer-mfa-self-service" {
  name       = "developer-mfa-self-service"
  groups     = ["${aws_iam_group.developer.name}"]
  policy_arn = "${aws_iam_policy.aws_mfa_self_service.arn}"
}

resource "aws_iam_policy_attachment" "developer-access-key-self-service" {
  name       = "developer-access-key-self-service"
  groups     = ["${aws_iam_group.developer.name}"]
  policy_arn = "${aws_iam_policy.aws_access_key_self_service.arn}"
}

resource "aws_iam_policy_attachment" "developer-list-iam-users" {
  name       = "developer-list-iam-users"
  groups     = ["${aws_iam_group.developer.name}"]
  policy_arn = "${aws_iam_policy.aws_list_iam_users.arn}"
}

# Group policies
data "aws_iam_policy_document" "assume_role_admin_access_group_policy_document" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    resources = [
      "${aws_iam_role.admin_access_role.arn}",
    ]
  }
}

resource "aws_iam_group_policy" "assume_role_admin_access_group_policy" {
  name  = "admin_access_group_policy"
  group = "${aws_iam_group.admins.id}"

  policy = "${data.aws_iam_policy_document.assume_role_admin_access_group_policy_document.json}"
}

data "aws_iam_policy_document" "assume_role_developer_access_group_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "${aws_iam_role.developer_access_role.arn}",
    ]
  }
}

resource "aws_iam_group_policy" "assume_role_developer_access_group_policy" {
  name  = "developer_access_group_policy"
  group = "${aws_iam_group.developer.id}"

  policy = "${data.aws_iam_policy_document.assume_role_developer_access_group_policy_document.json}"
}
