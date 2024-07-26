resource "aws_iam_role" "eb_instance_role" {
  name = "eb_instance_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "eb_s3_access" {
  name        = "eb_s3_access"
  description = "Allows Elastic Beanstalk instances to access S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::my-django-app-bucket-unique-12345",
          "arn:aws:s3:::my-django-app-bucket-unique-12345/deployment/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eb_instance_policy_web_tier" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "eb_instance_policy_multicontainer_docker" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role_policy_attachment" "eb_instance_policy_s3_access" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = aws_iam_policy.eb_s3_access.arn
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "eb_instance_profile"
  role = aws_iam_role.eb_instance_role.name
}
