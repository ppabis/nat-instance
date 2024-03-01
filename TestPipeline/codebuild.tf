resource "aws_codebuild_project" "NatTestProject" {
  name         = "NatTestProject"
  service_role = aws_iam_role.CodeBuildRole.arn

  artifacts { type = "CODEPIPELINE" }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
    git_clone_depth = 1
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-aarch64-standard:3.0"
    type         = "ARM_CONTAINER"
    environment_variable {
      name  = "TESTING_SSM_ROLE"
      value = aws_iam_role.SSMRole.name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "codebuild/NatTestProject"
      stream_name = "NatTestProject"
    }
  }

}
