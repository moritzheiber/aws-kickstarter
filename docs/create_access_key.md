# Setting up CLI access credentials for user accounts

[AWS IAM](https://aws.amazon.com/iam/) allows for you to use a pair of keys, called "Access Key" and "Secret Access Key", to access the AWS API and any of the services you're allowed to use, defined through [IAM policies and roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html). IAM and the way it's configured is a tricky and elaborate topic which this guide wont' be covering, but we will show you how to create the credentials ("Access Key", "Secret Access Key") to use with tools like [Terraform](https://www.terraform.io/) or the AWS CLI.

There are three types of accounts you can use to log into an AWS account, a so-called `root` account, IAM user accounts and federated user accounts (SAML/AD).
- `root` accounts are synonymous with the credentials you created initially when signing up for AWS. It's usually an email address and a password (and hopefully a 2FA/MFA code). `root` account users are "all-capable" and their permissions cannot be curtailed (unless they are a part of an [AWS Organization](https://aws.amazon.com/organizations/)).
- A IAM user account or federated user account are essentially treated the same way by AWS, as in, their access rights and roles are managed in AWS IAM. It's just that with regular IAM users, the user management is also done within AWS, whereas with federated users the user management is delegated to an outside, trusted entity, usually called an Identiy Provider or IdP (a corporate Active Directory, [Auth0](https://auth0.com/docs/integrations/aws), [Okta](https://www.okta.com/free/aws/)) and users are signing into AWS using these outside providers, which are communicating with AWS over [SAML](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_saml.html). Afterwards, the same policies and roles can be applied to either user (IAM or federated).

For all three of them there are ways to obtain temporary credentials securely, however, this document is only describing how to create credentials for **IAM users**.

For creating `root` account credentials (which you should ever only do temporarily and for a limited amount of time) refer to the [guide about creating initial credentials](initial_credentials.md) for running the scenarious described in this kickstarter.

For federated users there is an excellent tool called [`saml2aws`](https://github.com/Versent/saml2aws) which allows for you to use an established IdP to aquire temporary access credentials for CLI use. This assumes you have already [established federated identity trust](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create.html) between your AWS account and your IdP.

## Prerequisites

- AWS CLI (>= 1.15.49)

## Create initial passwords for users

For this you'll need your `root` account, because no other account has been configured yet which has the same level of privileges. Use the Web Console and your username and password for your AWS account. Once logged in, proceed as follows:

1. Select the "Services" dropdown from the upper left corner
2. Search for "IAM" in the build-in search
3. Click on first, and only, result
4. You should now see a console in front of you where it says "Users" on the left hand side. Click on "Users".
5. Click on any users you want to assign a password to and go to the tab "Security credentials"
6. Select "Manage password" and assign a good and secure password, and you will probably also want to select "User must create a new password at next sign-in"
7. Repeat these steps for any users you want to assign passwords to

Distribute these passwords securely to the relevant users, let them log into the Web Console on their own afterwards and continue the following setup.

_Note: You can provision user login profiles (i.e. your password) using Terraform and GPG keys without having to set passwords manually. For more information please refer to the [Terraform documentation for aws\_iam\_login\_profile](https://www.terraform.io/docs/providers/aws/r/iam_user_login_profile.html)._

## Create user access credentials

Log into your AWS account by using the credentials provided for the Web Console. The login form should be available at your account's [https://account-\<your-account-id\>.signin.aws.amazon.com/console](https://account-\<your-account-id\>.signin.aws.amazon.com/console). _Note: This is an **account specific login form for IAM users** and will only work for IAM users for that specific account._

_Note: Don't mind the error messages. Your bare IAM account doesn't have enough permissions to access all of the IAM API._

1. Select the "Services" dropdown from the upper left corner
2. Search for "IAM" in the build-in search
3. Click on first, and only, result
4. You should now see a console in front of you where it says "Users" on the left hand side. Click on "Users".
5. Click on your username in the list and go to the tab "Security credentials"

Now, depending on whether or not you have enabled [MFA](https://en.wikipedia.org/wiki/Multi-factor_authentication)-protected sessions you will be able to continue without having added a MFA device. The scenarios in this kickstarter all rely on it though, which is why, going forward, MFA for user accounts will be enabled and used:

1. Click on "Manage" next to "Assigned MFA device" (it should read "Not assigned" next to it). You **have to choose virtual MFA** here, even if you own a physical key (YubiKey/Nitrokey). Hardware MFA keys (U2F/FIDO or other Amazon specific devices) [aren't supported (yet)](https://github.com/aws/aws-cli/issues/3607) for CLI access as a second factor. Recommended apps to complete the process with would be [OTP Auth on iOS](https://apps.apple.com/us/app/otp-auth/id659877384) or [andOTP for Android](https://github.com/andOTP/andOTP).

2. Follow the steps outlined in the wizard and complete your MFA association. Once it's done there should be a device ARN akin to `arn:aws:iam::<your-account-id>:mfa/username` instead of "No" next to "Assigned MFA device".

3. Log out of your AWS account. This is necessary because your current session doesn't carry [a MFA session token](https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/), which is needed to access certain IAM functionality usually.

You are now set with your IAM user account, including a MFA "device", which is associated with it, providing an extra level of security. Continue with:

1. Use the Web Console to log into your AWS account with your IAM user credentials (it will also ask you for your MFA TOTP token this time)
2. Navigate the "Security Credentials" tab in your IAM user profile again
3. Select "Create access key"
4. Click on "Show Access Key"
5. Note down both of the values and close the overlay.

**Note: This is extremely important. DO NOT SHARE THESE TWO VALUES WITH ANYONE, EVER.** Both of them together are the representation of you user entity, with all of its privileges attached.

## Setting up the AWS CLI

You can now set up a "profile" for using the AWS CLI (and pretty much any other tooling using the [AWS SDK](https://docs.aws.amazon.com/index.html?nc2=h_ql_doc#sdks)). You can call this profile by any name you want, the suggestion would be to call it the same as the AWS IAM account alias you might have added to your account (the kickstarter scenarios allow for you to specify such an alias):

```sh
$ aws configure --profile my_account
```

_Note: You can call your profile by any name that you want, it doesn't have to be `my_account`. Just make sure the following code examples are adjusted accordingly where `my_account` is used as an identifier._

For the `AWS Access Key ID` and `AWS Secret Access Key` use the values you've just written down. The default region can be [any region you prefer](https://github.com/jsonmaur/aws-regions). You need to specify them with their "Region code" (i.e. `eu-central-1` or `us-east-1`). The output format doesn't matter.

## Setting up role assumption

All of the scenarios involving users and user management are configuring "bare" user accounts, with just enough permissions to set their own passwords, associate MFA devices and manage their Access Keys, **but not for managing resources**. For that, users have to assume to either the **resource-admin** (includes IAM permissions) or **resource-user** IAM role. Luckily, the CLI (and most of the SDKs) allow for this to happen transparently.

Add the following snippet to your CLI configuration file (usually located at `~/.aws/config`):

_Note: `region` should be your preferred region_

```
[profile my_resource_account]
region = eu-central-1
role_arn = <arn-for-the-role-of-the-role-to-assume>
source_profile = my_account
mfa_arn = arn:aws:iam::<your-account-id>:mfa/<username>
```

Here is an explanation for the above:

- `role_arn`: Every resource within AWS has a unique identifier, called **ARN** ([Amazon Resource Name](https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html)), and so does the role you're trying to assume. Now, you might want to use the _name_ of the role instead (e.g. `resource-admin`) but that would only be valid for roles _within the same account_. However, IAM is a global service, and you can also use it to **temporarily assume credentials in other AWS accounts** that are outside of your direct control or supervision (if the setup allows for it and the other AWS account has added you as a trusted entity). The `iam_two_accounts` scenario is an example for such a practice. The `role_arn` for your regular setup can either be found using the Web Console in IAM or as an output variable on either of the IAM related scenarios of this kickstarter (`iam_one_account` and `iam_two_accounts`).
- `source_profile`: This is the original profile the CLI (or SDK) is supposed to use to talk to the AWS API about _assuming_ other credentials. Without the initial setup the CLI wouldn't know how to talk to AWS. This must correspond with the name of the profile you set up earlier.
- `mfa_arn`: As previously explained, any entity within AWS has an ARN. So does the MFA device you added earlier. You can look it up in your user profile under the "Security Credentials" tab or via the CLI by running `AWS_PROFILE="my_account" aws iam list-mfa-devices --user-name <your-username>` (make sure to use the right account profile, region and username).

To test your access you can run:

```sh
$ AWS_PROFILE="my_resource_account" aws --region eu-central-1 ec2 describe-instances
{
    "Reservations": []
}
```

An empty list (`[]`) is a valid response since you haven't commissioned any resources yet.

Congratulations. From now on you can use AWS on the command line through the profile `my_resource_account` if you want to use regular services like EC2, RDS or S3, and `my_account` whenever you want to use the IAM API for certain operations (such as rotating your Access Key or looking up your MFA device).

### A note for SAML users

Escalating your privileges using role assumption also works when there isn't a IAM user account tied directly into your AWS account. However, since an IdP "foreign" to AWS cannot feasible tell AWS whether or not a session is MFA authenticated you'll have to use the above snippet without the `mfa_arn` parameter:

```
[profile my_resource_account]
region = eu-central-1
role_arn = <arn-for-the-role-of-the-role-to-assume>
source_profile = my_account
```

`source_profile` should be the profile you have set up for `saml2aws` (as mentioned earlier). Afterwards, everything will work in the same way.
