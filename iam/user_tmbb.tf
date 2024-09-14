resource "aws_iam_user" "tmbb" {
 name = "tmbb"
}

resource "aws_iam_user_policy" "lee_devops_black_for_tmbb" {
  name  = "super-admin"
  user  = aws_iam_user.tmbb.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
} 
