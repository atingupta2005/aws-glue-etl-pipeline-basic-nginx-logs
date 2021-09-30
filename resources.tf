
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "aws_iam_glue_role" {
  name = "AWSGlueServiceRoleDefault"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "glue_service_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  role = aws_iam_role.aws_iam_glue_role.id
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_policy"
  role = aws_iam_role.aws_iam_glue_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.bucket_for_glue}",
        "arn:aws:s3:::${var.bucket_for_glue}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "glue_service_s3" {
  name = "glue_service_s3"
  role = aws_iam_role.aws_iam_glue_role.id
  policy = aws_iam_role_policy.s3_policy.policy
}

resource "aws_s3_bucket" "bucket_for_glue" {
  bucket = var.bucket_for_glue
  force_destroy = true
}
