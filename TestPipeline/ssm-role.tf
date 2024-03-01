resource "aws_iam_role" "SSMRole" {
  name               = "SSMRole"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "SSMManagedInstanceCore" {
  role       = aws_iam_role.SSMRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "SSMRole" {
  name = "SSMRole"
  role = aws_iam_role.SSMRole.name
}
