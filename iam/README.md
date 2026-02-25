## AWS Identity and Access Management (IAM)

AWS IAM allows you to create and manage AWS users and groups, with permissions to allow and deny them access to AWS resources.

1. **IAM Policies**: JSON documents which grant permissions to a specific user, group, or role to access AWS services. Policies are attached to IAM Identities.
2. **IAM Permission**: The API call that is allowed or denied, according to the IAM Policy.
3. **IAM Identity**: A user, group, or role that is allowed or denied access to AWS resources.
    - **IAM User**: A user is an identity that represents a person who logs into the console or interacts with AWS resources programmatically or via clickOps.
    - **IAM Group**: A group is a collection of users that are granted the same permissions. Groups are used to simplify the management of permissions for multiple users.
    - **IAM Role**: A role grants AWS resources permissions to specific AWS API actions. Policies are associated with roles, then assigned to an AWS resource.

#### IAM - Managed vs Customer vs Inline Policies

- **Managed Policies**: A policy that is managed by AWS, which cannot be edited by users. In AWS, managed policies are labeled with an orange box icon.

    ![Managed Policies](./images/aws-managed-policies.png)
- **Customer Managed Policies**: A policy that is managed by users, which can be edited by users. In AWS, customer managed policies have no label.

    ![Customer Managed Policies](./images/aws-customer-managed-policies.png)
- **Inline Policies**: A policy that is directly attached to the user.

    ![Inline Policies](./images/aws-inline-policies.png)

### Anatomy of an IAM Policy

IAM policies are written in JSON, and contain permissions, which determine which API actions are allowed and which ones are denied. 

#### JSON IAM Example

```JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Deny-Barclay-S3-Access",
            "Effect": "Deny",
            "Action": "s3:*",
            "Principal": {"AWS": ["arn:aws:iam:123456789012:barclay"]},
            "Resource": "arn:aws:s3:::barclay-s3-bucket"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": [
                        "rds.amazonaws.com",
                        "rds.application-autoscaling.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
```
#### YAML IAM Example

```yaml
Version: "2012-10-17"
Statement:
  - Sid: Deny-Barclay-S3-Access
    Effect: Deny
    Action: s3:*
    Principal:
      AWS:
        - arn:aws:iam:123456789012:barclay
    Resource: arn:aws:s3:::barclay-s3-bucket
  - Effect: Allow
    Action: iam:CreateServiceLinkedRole
    Resource: '*'
    Condition:
      StringLike:
        iam:AWSServiceName:
          - rds.amazonaws.com
          - rds.application-autoscaling.amazonaws.com
```
YAML can be converted to JSON using the `yq` command-line tool.

```bash
yq -o json policy.yaml > policy.json
```

- **Version policy language**: 2012-10-17 is the latest version.
- **Statement**: A list of permissions.
- **Sid**(Optional): A unique identifier for a statement.
- **Effect**: Allow or Deny.
- **Action**: List of API action to allow or deny.
- **Principal**: The user, group, or role that is allowed or denied access to AWS resources.
- **Resource**: The AWS resource to which the action applies.
- **Condition**(Optional): Circumstances under which the policy grants permissions.

### Principle Of Least Privilege (PoLP) 

**Principle of Least Privilege** is a computer security concept of providing a user, role, or application the least amount of permissions necessary to perform its job functions. 

- **Just-Enough-Access (JEA)**: Permitting only the exact actions for the identity to perform an action.
- **Just-In-Time (JIT)**: Permitting access for the smallest amount of time necessary to perform an action.

**ConsoleMe**

ConsoleMe is an open-source Netflix project to self-serve short-lived IAM policies so an end user can access AWS resources while enforcing JEA and JIT. 

**Risk-based Adaptive POlicies**

Each attempt to access AWS resources generates a risk score of how likely the request is to be from a compromised source. The risk could be based on many factors, eg. device, user loaction, IP address, service being accesses, and when.


### AWS Account Root User

AWS Account Root User is a user who is created at the time of the AWS Account creation. It has all the permissions in the AWS Account.
- The Root User account uses an email & password to login.
  - A regular user has to provide the Account ID/Alias, username & password to login.
- The Root User account cannot be deleted whatsoever.
- The Root User has full permissions to the account and it's permissions cannot be restricted whatsoever.
  - IAM policies cannot be used to explicitly deny the Root User account access to any AWS resource.
  - Only AWS Organizations Service Control Policies (SCPs) can be used to limit permissions of the Root User account.
- There can only be one Root User account per AWS Account.
- The root user should only be used for specific and specialized tasks that are rarely performed.
- An AWS Root Account should not be used for day-to-day tasks.
- It is strongly recommended to never use Root User access Keys.
- It is strongly recommended to turn on MFA for the Root User account.

#### Root User Tasks

- Change Account Settings:
  - Includes the account name, email address, root user password, and root user access keys.
  - Other accounts settings such as contact info, payment currency, and regions, do not requre root user credentials.
- Restore IAM User permissions:
  - If the only IAM Admin accidentally revokes their own permissions, the Root User can restore their permissions.
- Activate IAM Access to the Billing and Cost Management Console.
- View certain tax invoices.
- Close an AWS Account.
- Change or Cancel AWS Support Plan.
- Register as a seller in the Reservec Instance Marketplace.
- Enable MFA Delete on an S3 bucket.
- Edit or delete an Amazon S3 bucket policy that includes an invalid VPC ID or VPC Endoint ID.
- Sign up for GovCloud.

