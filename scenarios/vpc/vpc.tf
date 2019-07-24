module "core_vpc" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//vpc?ref=v0.3.5"

  tags = var.tags
}
