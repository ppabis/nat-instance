/**
  This AMI will be used if `custom_ami` is not specified via variables.
*/
data "aws_ssm_parameter" "AL2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}
