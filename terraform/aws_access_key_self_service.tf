# This is a policy which lets you self-service your own access keys.
# The only condition is that you have a MFA enabled session
data "aws_iam_policy_document" "aws_access_key_self_service_policy" {
  statement {
    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey",
    ]

    effect = "Allow"

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

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}",
    ]
  }
}

resource "aws_iam_policy" "aws_access_key_self_service" {
  name        = "aws_access_key_self_service"
  path        = "/"
  description = "Policy for access key self service"

  policy = data.aws_iam_policy_document.aws_access_key_self_service_policy.json
}

