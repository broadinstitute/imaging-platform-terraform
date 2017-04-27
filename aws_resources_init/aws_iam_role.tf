resource "aws_iam_role" "imaging-platform-terraform" {
  name = "imaging-platform-terraform"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "imaging-platform-terraform-AmazonEC2FullAccess" {
    name = "imaging-platform-terraform-AmazonEC2FullAccess"
    roles = ["${aws_iam_role.imaging-platform-terraform.id}"]
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
