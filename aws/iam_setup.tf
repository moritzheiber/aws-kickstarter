resource "aws_iam_account_alias" "iam_account_alias" {
  account_alias = "${var.iam_account_alias}-${data.aws_caller_identity.current.account_id}"
}
