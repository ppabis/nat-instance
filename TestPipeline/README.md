CodePipeline and CodeBuild for the NAT instance
================================================
This module is not to be imported to the parent repository. This is only to be
used to deploy the testing pipeline. Don't treat it as a module for testing.
`cd` to this directory and run `terraform init` and `terraform apply` to deploy.

Change the repository, create your own Git connection, change S3 bucket name and
so on.

The SSM role in `ssm-role.tf` is created here as well to skip giving too many
IAM permission to CodePipeline - it only has `iam:PassRole` on it.

However, CodePipeline still has quite extensive permissions: full EC2, VPC, SSM
access. **Do not use** this in your main AWS account. And put some SCP on top to
prevent spawning some expensive GPU or u-12tb instances.