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

data "aws_iam_policy_document" "developer_access_no_vpc_access_policy_document" {
  statement {
    effect = "Deny"

    actions = [
      "ec2:AcceptVpcPeeringConnection",
      "ec2:AssociateDhcpOptions",
      "ec2:AssociateRouteTable",
      "ec2:AttachClassicLinkVpc",
      "ec2:AttachInternetGateway",
      "ec2:AttachVpnGateway",
      "ec2:CreateCustomerGateway",
      "ec2:CreateDhcpOptions",
      "ec2:CreateFlowLogs",
      "ec2:CreateInternetGateway",
      "ec2:CreateNatGateway",
      "ec2:CreateNetworkAcl",
      "ec2:CreateNetworkAclEntry",
      "ec2:CreateRoute",
      "ec2:CreateRouteTable",
      "ec2:CreateSubnet",
      "ec2:CreateVpc",
      "ec2:CreateVpcPeeringConnection",
      "ec2:CreateVpnConnection",
      "ec2:CreateVpnConnectionRoute",
      "ec2:CreateVpnGateway",
      "ec2:DeleteCustomerGateway",
      "ec2:DeleteDhcpOptions",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteNatGateway",
      "ec2:DeleteNetworkAcl",
      "ec2:DeleteNetworkAclEntry",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",
      "ec2:DeleteSubnet",
      "ec2:DeleteVpc",
      "ec2:DeleteVpnConnection",
      "ec2:DeleteVpnConnectionRoute",
      "ec2:DeleteVpnGateway",
      "ec2:DetachClassicLinkVpc",
      "ec2:DetachInternetGateway",
      "ec2:DetachVpnGateway",
      "ec2:DisableVgwRoutePropagation",
      "ec2:DisableVpcClassicLink",
      "ec2:DisableVpcClassicLinkDnsSupport",
      "ec2:DisassociateRouteTable",
      "ec2:EnableVgwRoutePropagation",
      "ec2:EnableVpcClassicLink",
      "ec2:EnableVpcClassicLinkDnsSupport",
      "ec2:ModifySubnetAttribute",
      "ec2:ModifyVpcAttribute",
      "ec2:ModifyVpcEndpoint",
      "ec2:ModifyVpcPeeringConnectionOptions",
      "ec2:MoveAddressToVpc",
      "ec2:RejectVpcPeeringConnection",
      "ec2:ReplaceNetworkAclAssociation",
      "ec2:ReplaceNetworkAclEntry",
      "ec2:ReplaceRoute",
      "ec2:ReplaceRouteTableAssociation",
      "ec2:RestoreAddressToClassic",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "developer_access_no_vpc_access_policy" {
  name        = "developer_access_no_vpc_access"
  path        = "/"
  description = "deny user access to VPC related commands"

  policy = "${data.aws_iam_policy_document.developer_access_no_vpc_access_policy_document.json}"
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

resource "aws_iam_policy_attachment" "developer_access_no_vpc_access_policy_attachment" {
  name       = "developer_access_no_vpc_access_policy_attachment"
  roles      = ["${aws_iam_role.developer_access_role.name}"]
  policy_arn = "${aws_iam_policy.developer_access_no_vpc_access_policy.arn}"
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
