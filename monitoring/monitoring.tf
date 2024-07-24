resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/elasticbeanstalk/app"
  retention_in_days = 14
}
