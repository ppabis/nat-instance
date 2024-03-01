resource "random_string" "name" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "codepipeline-artifacts-nat-test" {
  bucket = "codepipeline-nat-test-${random_string.name.result}"
}
