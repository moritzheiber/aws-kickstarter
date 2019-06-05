data "aws_iam_policy_document" "aws_list_iam_users_policy" {
  statement {
    effect = "Allow"

    actions = [
      "iam:GetAccountSummary",
      "iam:ListAccountAliases",
      "iam:ListGroupsForUser",
      "iam:ListUsers",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:*",
    ]
  }

  statement {
    actions = ["iam:GetUser"]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}",
    ]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "aws_list_iam_users" {
  name        = "aws_list_iam_users"
  path        = "/"
  description = "Let users see the list of users"

  policy = data.aws_iam_policy_document.aws_list_iam_users_policy.json
}

