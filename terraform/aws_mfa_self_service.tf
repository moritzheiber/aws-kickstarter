data "aws_iam_policy_document" "aws_mfa_self_service_policy" {
  statement {
    effect = "Allow"

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}",
    ]

    actions = [
      "iam:DeactivateMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:ListVirtualMFADevices",
      "iam:ListMFADevices",
    ]
  }

  statement {
    effect = "Allow"

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/$${aws:username}",
    ]

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
    ]
  }

  statement {
    effect = "Allow"

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/*",
    ]

    actions = [
      "iam:ListVirtualMFADevices",
      "iam:ListMFADevices",
    ]
  }
}

resource "aws_iam_policy" "aws_mfa_self_service" {
  name        = "aws_mfa_self_service"
  path        = "/"
  description = "Policy for MFA self service"

  policy = "${data.aws_iam_policy_document.aws_mfa_self_service_policy.json}"
}
