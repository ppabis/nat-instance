resource "aws_codepipeline" "NATPipeline" {
  name = "NATPipeline"

  artifact_store {
    location = aws_s3_bucket.codepipeline-artifacts-nat-test.bucket
    type     = "S3"
  }
  role_arn      = aws_iam_role.CodePipelineNatTestRole.arn
  pipeline_type = "V2"

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      input_artifacts  = []
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.GitHub.arn
        FullRepositoryId = "ppabis/nat-instance"
        BranchName       = "main"
        DetectChanges    = "true"
      }
    }
  }


  stage {
    name = "Test"

    action {
      name             = "Test"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["test_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.NatTestProject.name
      }
    }
  }
}
