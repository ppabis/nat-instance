### Allow new instances to register in Systems Manager

resource "aws_iam_role" "ssm-instance" {
  count              = var.SSM-Role == null ? 1 : 0
  name               = "SSM-Instance"
  assume_role_policy = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [ {
            "Action": "sts:AssumeRole",
            "Principal": { "Service": [ "ec2.amazonaws.com" ] },
            "Effect": "Allow",
            "Sid": "EC2SSM"
        } ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "SSM-ManagedInstanceCore" {
  count      = var.SSM-Role == null ? 1 : 0
  role       = aws_iam_role.ssm-instance[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm-profile" {
  count = var.SSM-Role == null ? 1 : 0
  name  = "SSM-Instance-Profile"
  role  = aws_iam_role.ssm-instance[0].name
}
