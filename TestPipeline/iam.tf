resource "aws_iam_role" "CodeBuildRole" {
  name               = "CodeBuildRole"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "codebuild.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
      ]
    }
    EOF
}

data "aws_iam_policy_document" "CodeBuildNATTest" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.SSMRole.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:*",
      "ec2:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:Put*",
      "s3:AbortMultipartUpload",
      "s3:List*",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion"
    ]
    resources = [
      aws_s3_bucket.codepipeline-artifacts-nat-test.arn,
      "${aws_s3_bucket.codepipeline-artifacts-nat-test.arn}/*"
    ]

  }
}

resource "aws_iam_role_policy" "CodeBuildNATTestPolicy" {
  name   = "CodeBuildNATTestPolicy"
  role   = aws_iam_role.CodeBuildRole.name
  policy = data.aws_iam_policy_document.CodeBuildNATTest.json
}

// ------------------------------
// --- CodePipeline Role and Policy
// ------------------------------

data "aws_iam_policy_document" "CodePipelineNatTestPolicy" {
  statement {
    effect = "Allow"
    actions = [
      "codestar-connections:UseConnection"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuildBatches",
      "codebuild:StartBuildBatch",
      "codebuild:StopBuild"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:Put*",
      "s3:AbortMultipartUpload",
      "s3:List*",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion"
    ]
    resources = [
      aws_s3_bucket.codepipeline-artifacts-nat-test.arn,
      "${aws_s3_bucket.codepipeline-artifacts-nat-test.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "CodePipelineNatTestPolicy" {
  name   = "CodePipelineNatTestPolicy"
  policy = data.aws_iam_policy_document.CodePipelineNatTestPolicy.json
}

resource "aws_iam_role" "CodePipelineNatTestRole" {
  name               = "CodePipelineNatTestRole"
  assume_role_policy = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "Service": "codepipeline.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
            }
        ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "CodePipelineNatTestPolicy" {
  role       = aws_iam_role.CodePipelineNatTestRole.name
  policy_arn = aws_iam_policy.CodePipelineNatTestPolicy.arn
}
