provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "pydoro_server" {
  instance_type = "t2.micro"
  ami           = "ami-244c7a39"
  user_data = <<EOF
#!/usr/bin/env bash
mkdir -p /srv/pydoro
aws s3 cp s3://pydoro-artifacts/backend/${var.backend-version}.zip /srv/pydoro/dist.zip
cd /srv/pydoro/
unzip dist.zip
pip3 install -r requirements.txt
python3 main.py
EOF
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "pydoro-artifacts"
  acl    = "private"
}

resource "aws_iam_policy" "ec2_allow" {
  name   = "ec2_allow"
  policy = data.aws_iam_policy_document.ec2_allow.json
}

resource "aws_iam_role" "ec2_role" {
  name               = "ec2_role"
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

resource "aws_iam_role_policy_attachment" "ec2_role_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_allow.arn
}

data "aws_iam_policy_document" "ec2_allow" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:GetObjectTagging"]
    resources = ["arn:aws:s3:::pydoro-artifacts/*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetBucketTagging"]
    resources = ["arn:aws:s3:::pydoro-artifacts"]
  }
}

resource "aws_iam_instance_profile" "ec2_role_profile" {
  name = "ec2_role_profile"
  role = aws_iam_role.ec2_role.name
}
