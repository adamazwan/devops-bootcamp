data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

module "rackula" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.4"

  name                        = "tf4-rackula"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = module.my_vpc.public_subnets[0]
  vpc_security_group_ids      = [module.rackula_sg.id]
  create_security_group       = false
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ssm.name

  user_data = templatefile("${path.module}/userdata.sh", {})

  tags = { Name = "tf4-rackula" }
}
