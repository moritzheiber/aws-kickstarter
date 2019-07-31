# Initial Credential Setup

## Prerequisites

- [AWS CLI](https://aws.amazon.com/cli/) (>= 1.15.49)

## Preface

The initial setup of your credentials will require you to use your `root` account. It's the login you initially signed up for AWS with. You can then create a set of initial `root` credentials once using the AWS Web Console, which in turn allow you to create a set of lower-privilege credentials you can then use to further provision your account.

_Note: You should never use your `root` account credentials outside of provisioning other, lower-tier IAM-level privileged users and access credentials. Your `root` account is the one and only entrypoint into your AWS account, its credentials are uncurtailed and should never exist beyond a short, purpose-driven amount of time!_

## Setup

### Create initial root credentials

1. Log into your AWS account using the AWS Web Console and navigate to the dropdown on the top right corner with your email address or the name you gave the account on it
2. Select "My Security Credentials"
3. Discard the warning screen by clicking on "Continue to Security Credentials", we will only be doing this once and removing the access credentials afterwards
4. Select "Access keys (access key ID and secret access key)"
5. Select "Create new access key"
6. Click on "Show Access Key"
7. Note down both of the values and close the overlay.

### Set up local root credential profile

Set up a profile for the root credentials with the AWS CLI:

```sh
$ aws configure --profile root-account
```

_Note: You can call your profile by any name that you want, it doesn't have to be `root-account`. Just make sure the following code examples are adjusted accordingly where `root-account` is used as an identifier._

For the `AWS Access Key ID` and `AWS Secret Access Key` use the values you've just written down. The default region can be [any region you prefer](https://github.com/jsonmaur/aws-regions). You need to specify them with their "Region code" (i.e. `eu-central-1` or `us-east-1`). The output format doesn't matter.

To test your access you can run:

```sh
$ AWS_PROFILE="root-account" aws --region eu-central-1 ec2 describe-instances
{
    "Reservations": []
}
```

An empty list (`[]`) is a valid response since you haven't commissioned any resources yet.

You can now continue with the any of the scenarios of the kickstarter.

**Make sure to remove the Security Credentials you created earlier from you root account afterwards!**. Even if you should need them again in the future you should invalidate/delete them now and create new credentials (and run through the above process once more) when you want to provision you're done.

### Remove the root credentials

Once you have provisioned users with sufficient privileges to manage your account (the `iam_one_account` or `iam_two_accounts` are examples for this) you should delete the Security Credentials in your `root` account again:

1. Log into your AWS account using the AWS Web Console and your email address you signed up with AWS for and navigate to the dropdown on the top right corner with your email address or the name you gave the account on it
2. Select "My Security Credentials"
3. Discard the warning screen by clicking on "Continue to Security Credentials"
4. Select "Access keys (access key ID and secret access key)"
5. Click on "[x]" on the right hand side in the table where it shows your available credentials
6. Confirm the "Delete Access Key" modal with "Yes"
7. Repeat the prior step for any Access Key that might have been added to your `root` account
