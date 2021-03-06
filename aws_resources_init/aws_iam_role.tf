resource "aws_iam_instance_profile" "imaging-platform-terraform" {

  name  = "imaging-platform-terraform"

  role = "${aws_iam_role.imaging-platform-terraform.name}"

}

resource "aws_iam_role" "imaging-platform-terraform" {

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

  name = "imaging-platform-terraform"

}

resource "aws_iam_policy_attachment" "imaging-platform-terraform-AmazonEC2FullAccess" {

    name = "imaging-platform-terraform-AmazonEC2FullAccess"

    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"

    roles = ["${aws_iam_role.imaging-platform-terraform.name}"]

}

resource "aws_iam_policy_attachment" "imaging-platform-terraform-CloudWatchLogsFullAccess" {

    name = "imaging-platform-terraform-CloudWatchLogsFullAccess"

    policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"

    roles = ["${aws_iam_role.imaging-platform-terraform.name}"]

}
