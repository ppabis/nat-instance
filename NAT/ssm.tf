### Allow new instances to register in Systems Manager

resource "aws_iam_role" "ssm-role" {
  count              = var.create_ssm_role ? 1 : 0
  name               = "${var.name_tag}-Role"
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
  count      = var.create_ssm_role ? 1 : 0
  role       = aws_iam_role.ssm-role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm-role" {
  count = var.create_ssm_role ? 1 : 0
  name  = "${var.name_tag}-Role"
  role  = aws_iam_role.ssm-role[0].name
}
