# AWS Kickstarter

This is a comprehensive toolkit for provisioning AWS accounts for a couple of common scenarios [in a secure way](https://www.thoughtworks.com/insights/blog/using-aws-security-first-class-citizen), with best practices applied by default. The kickstarter is using [a set of modules](https://github.com/moritzheiber/terraform-aws-core-modules) which are consistently tested and developed in an ongoing fashion.

## Prerequisites

The following tools are required:

- [Terraform](https://terraform.io) (**>= 0.12.4**)
- [awscli](https://aws.amazon.com/cli/) (>= 1.15.49)
- Any device (e.g. a [NitroKey](https://www.nitrokey.com/) or [YubiKey](https://www.yubico.com/product/yubikey-5-nfc)) and/or app (for either [Android](https://f-droid.org/repository/browse/?fdfilter=totp&fdid=net.bierbaumer.otp_authenticator) or [iOS](https://cooperrs.de/othauth.html)) that supports [2FA/TOTP](https://en.wikipedia.org/wiki/Multi-factor_authentication).

_Note: Although AWS [now supports](https://aws.amazon.com/blogs/security/use-yubikey-security-key-sign-into-aws-management-console/) the modern [FIDO2 procotol](https://fidoalliance.org/fido2/) for adding a second factor to your account [it lacks support for the command line](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_u2f_supported_configurations.html), which renders it an unsuable option for most of what you'd either do with this kickstarter or AWS APIs in general._

## Disclaimer

While some of the scenarios are (almost) free of charge (`iam_one_account`, `iam_two_accounts`, `config`), others **will cost you money once you have them provisioned**. This is especially true for the `vpc` scenario, and therefore, since these include the `vpc` scenario, also the `config_iam_vpc_one_account` and `config_iam_vpc_two_accounts` scenarios. The costs for the most elaborate of the scenarios (`config_iam_vpc_two_accounts`) is roughly $70/65 EUR _per month_ (and a lot less if you're testing it for a short while).

## Available scenarios

_Note: Any of these scenarios require for you to have at least CLI access to the AWS API, most of them even `root` level or `AdministratorAccess` privileges. A way of setting these up is described [in the documentation for setting up your initial credentials](docs/initial_credentials.md)._

Make it your practice to not only read this README but also the relevant Terraform source code files.

### One IAM account

Located in [`scenarios/iam_one_account`](scenarios/iam_one_account).

It defines a single account, where users assume either of two roles, `resource-admin` if they are a part of the `admin` group, or `resource-user` if they are a part of the `users` group. `resource-admin` allows for full access to the account, including IAM and Organizations. `resource-user` allows access to any other service _except_ IAM and Organizations. Use these privileges wisely.

The scenario contains two example users, `admin` and `user` to given you an idea of how you can create users along with using the modules.

To assume either of these roles, either use the Web Console to assume a role (<your-username-at-the-top-right> > Switch role) or through the AWS CLI. The relevant snippet for the AWS CLI would look like this:

```
[profile my_resource_account]
region = <my-region>
role_arn = <arn-for-the-role-of-the-role-to-assume>
source_profile = my_account
mfa_arn = arn:aws:iam::<your-account-id>:mfa/<username>
```

For more information and possible configuration parameters, please refer to the module documentation for [`iam-users`](https://github.com/moritzheiber/terraform-aws-core-modules#iam-users) and [`iam-resources`](https://github.com/moritzheiber/terraform-aws-core-modules#iam-resources).

### Two IAM accounts (or 1+n IAM accounts)

Located in [`scenarios/iam_two_accounts`](scenarios/iam_two_accounts).

This scenario works quite in the same way (in fact, it's using the exact same combination of modules) as the `iam_one_account` scenario, with an added twist: It provisions two accounts instead of one. You can find an explanation in [IAM setup section further down](#iam-setup).

You will need to have both AWS accounts created already and have followed [the guidelines as to create `root` level Access Keys](docs/initial_credentials.md) for these accounts and save them under separate profiles (e.g. `users_account` and `resource_account`). You will need these two profile names, along with the AWS account IDs for both accounts, to run the module.

The scenario contains two example users, `admin` and `user` to given you an idea of how you can create users along with using the modules. They will be able to assume roles in the "resource" account afterwards.

For more information and possible configuration parameters, please refer to the module documentation for [`iam-users`](https://github.com/moritzheiber/terraform-aws-core-modules#iam-users) and [`iam-resources`](https://github.com/moritzheiber/terraform-aws-core-modules#iam-resources).

### AWS Config

Located in [`scenarios/config`](scenarios/config).

For an explanation of AWS Config please refer to [AWS Config for auditing (and enforcement) purposes](#aws-config-for-auditing-and-enforcement-purposes).
For a list of configurable rules and remediations refer to [the module documentation for AWS Config](https://github.com/moritzheiber/terraform-aws-core-modules#config).

The module (and therefore the kickstarter) is still missing support for the following AWS Config functionalities: reporting via SNS, centralized aggregation of findings, remediations.

You will need to specify a `bucket_prefix` for the S3 bucket AWS Config is delivering its findings to, as well as a boolean which decides whether or not you want to enable S3 lifecycle management on the bucket (`enable_lifecycle_management_for_s3`). You will want to set this to true for a "production-grade" deployment, but leave it as `false` for testing purposes (which is why the example scenario is using `false`).

For more information and possible configuration parameters, please refer to the module documentation for [`config`](https://github.com/moritzheiber/terraform-aws-core-modules#config).

### VPC

Located in [`scenarios/vpc`](scenarios/vpc).

For a deep dive into the VPC setup this scenario is creating please refer to the [VPC network design](#vpc-network-design) section below. Generally, what you will want is to specify a few tags which allow for resource attribution within your account (e.g. billing purposes) using the `tags` variable. In this example, `tags` is set to:

```hcl
{
  Resource = "my_cost_center"
}
```

but it can be any number of tags you want to add to your resources.

For more information and possible configuration parameters, please refer to the module documentation for [`vpc`](https://github.com/moritzheiber/terraform-aws-core-modules#vpc).

### AWS Config + IAM in one account + VPC

Located in [`scenarios/config_iam_vpc_one_account`](scenarios/config_iam_vpc_one_account).

This is essentially a combination of the scenarios `iam_one_account`, `config` and `vpc`, all configured in one account.

### AWS Config + IAM in two accounts (or 1+n) + VPC

Located in [`scenarios/config_iam_vpc_two_accounts`](scenarios/config_iam_vpc_two_accounts).

This is a combination of all available core modules, provisioned into more than one account. This is about as secure and modeled after best practices as it can get. If you have more than one account, **use this scenario to kickstart your efforts**, otherwise use the `iam_one_account` alternative.

## Upcoming scenarios

- `cloudtrail`: Enables and configures AWS CloudTrail for logging and auditing purposes.
- `state-bucket`: Provisions and configures a S3 bucket for storing Terraform state.

# Behind the kickstarter

## IAM setup
The kickstarter is using the paradigm of a MFA-enabled account assumption model, whereas users aren't granted permissions directly for their users, but rather will have to [assume certain roles] in order to carry out activities (e.g. starting workloads, creating resources, saving files etc.). They can do this either in the web console, or, preferably, using the API (e.g. through this kickstarter using Terraform).

![AWS IAM setup](https://raw.githubusercontent.com/moritzheiber/terraform-aws-core-modules/master/files/aws_iam_setup.png)

## VPC Network design

The VPC setup you're getting with this kickstarter is a classic DMZ-model, whereas resources are never directly exposed to the public Internet but are rather living in their separate zone, segregated from other publicly accessible resources. Ideally, those are only load balancers or edge endpoints, but never actual instances or functions with compute workloads.

![AWS VPC setup](https://raw.githubusercontent.com/moritzheiber/terraform-aws-core-modules/master/files/aws_vpc.png)


## AWS Config for auditing (and enforcement) purposes

[AWS Config](https://aws.amazon.com/config/) is an integral service for achieving compliance and assurance on AWS. With it, you're able to define guardrails and boundaries by which the account needs to adhere to be "compliant" and even define "remediations" (such as instance shutdowns, revoking credentials or blocking access to certain parts of the account).
