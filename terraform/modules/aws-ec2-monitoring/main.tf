# *********************************************************************
# *************           IBERIA L.A.E.                   *************
# *************       by Software Engineering             *************
# *********************************************************************

# ##############################
# ## cloudwatch log subscription
# ##############################
resource "aws_cloudwatch_log_subscription_filter" "lambda_logfilter" {
  # A name for the subscription filter
  name            = "test_lambdafunction_logfilter"
  # The ARN of an IAM role that grants Amazon CloudWatch Logs permissions 
  # to deliver ingested log events to the destination. If you use Lambda as a destination, 
  # you should skip this argument and use aws_lambda_permission resource 
  # for granting access from CloudWatch logs to the destination Lambda function.
  role_arn        = aws_iam_role.iam_for_lambda.arn
  # The name of the log group to associate the subscription filter with
  log_group_name  = "/aws/lambda/example_lambda_name"
  # A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events.
  filter_pattern  = "logtype test"
  # The ARN of the destination to deliver matching log events to. Kinesis stream or Lambda function ARN.
  # destination_arn = aws_kinesis_stream.test_logstream.arn
  # The method used to distribute log data to the destination. 
  # By default log data is grouped by log stream, 
  # but the grouping can be set to random for a more even distribution.
  # This property is only applicable when the destination is an Amazon Kinesis stream. 
  # Valid values are "Random" and "ByLogStream".
  distribution    = "Random"
}


# ##############################
# ## cloudwatch alarm subscription 
# ## to aws autoscaling group
# ##############################
resource "aws_cloudwatch_metric_alarm" "bat" {
  # The descriptive name for the alarm. This name must be unique within the user's AWS account
  alarm_name          = "terraform-test-foobar5"
  # The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand.
  comparison_operator = "GreaterThanOrEqualToThreshold"
  # The number of periods over which data is compared to the specified threshold
  evaluation_periods  = "2"
  # The name for the alarm's associated metric.
  metric_name         = "CPUUtilization"
  # The namespace for the alarm's associated metric. See docs for the list of namespaces.
  namespace           = "AWS/EC2"
  # The namespace for the alarm's associated metric. See docs for the list of namespaces.
  period              = "120"
  # The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum
  statistic           = "Average"
  # The value against which the specified statistic is compared. 
  # This parameter is required for alarms based on static thresholds, 
  # but should not be used for alarms based on anomaly detection models.
  threshold           = "80"
  # The dimensions for the alarm's associated metric. 
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.bar.name
  }
  # The description for the alarm.
  alarm_description = "This metric monitors ec2 cpu utilization"
  # The list of actions to execute when this alarm transitions 
  # into an ALARM state from any other state. 
  # Each action is specified as an Amazon Resource Name (ARN).
  alarm_actions     = [aws_autoscaling_policy.bat.arn]
}
