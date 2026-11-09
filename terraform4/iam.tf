data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ssm" {
  name_prefix        = "rackula-ssm-"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = { Name = "tf4-rackula-ssm-role" }
}

resource "aws_iam_instance_profile" "ssm" {
  name_prefix = "rackula-ssm-"
  role        = aws_iam_role.ssm.name

  tags = { Name = "tf4-rackula-ssm-profile" }
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
