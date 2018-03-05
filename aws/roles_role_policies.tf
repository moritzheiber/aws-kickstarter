# Roles
data "aws_iam_policy_document" "admin_access_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = ["3600"]
    }

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }
}

resource "aws_iam_role" "admin_access_role" {
  name = "AdminAccess"

  assume_role_policy = "${data.aws_iam_policy_document.admin_access_role_policy.json}"
}

data "aws_iam_policy_document" "developer_access_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = ["14400"]
    }

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }
}

resource "aws_iam_role" "developer_access_role" {
  name = "DeveloperAccess"

  assume_role_policy = "${data.aws_iam_policy_document.developer_access_role_policy.json}"
}

# Policies
data "aws_iam_policy_document" "aws_admin_access_policy_document" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["*"]
  }
}

resource "aws_iam_policy" "aws_admin_access_policy" {
  name        = "aws_admin_access"
  path        = "/"
  description = "Admin access for roles"

  policy = "${data.aws_iam_policy_document.aws_admin_access_policy_document.json}"
}

data "aws_iam_policy_document" "aws_developer_access_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
    ]

    not_resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AdminAccess*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/DeveloperAccess*",
    ]
  }
}

resource "aws_iam_policy" "aws_developer_access_policy" {
  name        = "aws_developer_access"
  path        = "/"
  description = "Developer access for roles"

  policy = "${data.aws_iam_policy_document.aws_developer_access_policy_document.json}"
}

# Policy attachments for roles
resource "aws_iam_policy_attachment" "admin_access_policy_attachment" {
  name       = "admin_access_policy_attachment"
  roles      = ["${aws_iam_role.admin_access_role.name}"]
  policy_arn = "${aws_iam_policy.aws_admin_access_policy.arn}"
}

resource "aws_iam_policy_attachment" "developer_access_policy_attachment" {
  name       = "developer_access_policy_attachment"
  roles      = ["${aws_iam_role.developer_access_role.name}"]
  policy_arn = "${aws_iam_policy.aws_developer_access_policy.arn}"
}

resource "aws_iam_policy_attachment" "developer_access_iam_read_only_policy_attachment" {
  name       = "developer_access_iam_read_only_policy_attachment"
  roles      = ["${aws_iam_role.developer_access_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "developer_access_power_user_policy_attachment" {
  name       = "developer_access_power_user_policy_attachment"
  roles      = ["${aws_iam_role.developer_access_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
