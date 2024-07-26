resource "aws_s3_bucket" "app_bucket" {
  bucket = "my-django-app-bucket-unique-12345"
}

resource "aws_s3_object" "app_zip" {
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "deployment/django.zip"  # Adjust the path to include the file name
  source = "deployment/django.zip"   # Source file path
}

resource "aws_elastic_beanstalk_application" "app" {
  name        = "django-app"
  description = "Elastic Beanstalk Application for Django"
}

resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = "django-app-version"
  application = aws_elastic_beanstalk_application.app.name
  bucket      = aws_s3_bucket.app_bucket.bucket
  key         = "deployment/django.zip"  # Point to the zip file
}

resource "aws_elastic_beanstalk_environment" "app_env" {
  name                = "django-app-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v4.0.0 running Docker"
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"  # Adjust as needed
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "4"
  }
}
