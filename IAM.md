# IAM

Terraform state and locks are stored on AWS. We are using OIDC trust to authenticate to AWS using an IAM role.

## GitHub Actions secret

In the GitHub Actions workflow this is achieved using a secret called ROLE_TO_ASSUME, which contains the ARN for the IAM role.

## AWS IAM

### IAM Policy

This policy is shared with another pipeline that requires access to Route53 too.

Replace ACCOUNT_ID with your actual account ID where you have your DynamoDB table for Terraform locks.

Replace BUCKET_NAME with the name of your S3 state bucket.

Also replace HOSTED_ZONE_ID with an actual hosted zone id if you also want to manage Route53.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "dynamodb:PutItem",
                "route53:ChangeResourceRecordSets",
                "dynamodb:UpdateItem",
                "s3:ListBucket",
                "s3:GetObject",
                "s3:DeleteObject",
                "dynamodb:DescribeTable",
                "dynamodb:GetItem",
                "dynamodb:DeleteItem",
                "route53:GetHostedZone",
                "route53:ListTagsForResource",
                "route53:ListResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:s3:::<BUCKET_NAME>/*",
                "arn:aws:route53:::hostedzone/<HOSTED_ZONE_ID>",
                "arn:aws:dynamodb:eu-central-1:<ACCOUNT_ID>:table/terraform-locks"
            ]
        },
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```

### IAM Role

Permissions: Use the IAM Policy created above.

Replace ACCOUNT_ID with your actual account ID where you have your OIDC provider.

Replace REPO_NAME with your GitHub repository name in the format owner/repo.

#### Trust relationship

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
                    "token.actions.githubusercontent.com:sub": "repo:<REPO_NAME>:ref:refs/heads/main"
                }
            }
        }
    ]
}
```
