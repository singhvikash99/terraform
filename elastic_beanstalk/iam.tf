# Load the policies from the JSON file
locals {
  policies = jsondecode(file("iam_policies/policies.json"))
}

# IAM Role
resource "aws_iam_role" "eb_instance_role" {
  name = "eb_instance_role"

  assume_role_policy = jsonencode(local.policies.eb_instance_role_assume_policy)
}

# IAM Policy
resource "aws_iam_policy" "eb_s3_access" {
  name        = "eb_s3_access"
  description = "Allows Elastic Beanstalk instances to access S3 bucket"
  policy      = jsonencode(local.policies.eb_s3_access_policy)
}

# Attach AWS Managed Policies
resource "aws_iam_role_policy_attachment" "eb_instance_policy_web_tier" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "eb_instance_policy_multicontainer_docker" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

# Attach Custom IAM Policy
resource "aws_iam_role_policy_attachment" "eb_instance_policy_s3_access" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = aws_iam_policy.eb_s3_access.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "eb_instance_profile"
  role = aws_iam_role.eb_instance_role.name
}
