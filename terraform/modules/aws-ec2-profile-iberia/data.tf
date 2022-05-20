##########################################
# amazon ssm policy
##########################################
data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# add new policy amazon
data "aws_iam_policy" "SSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

##################
# global policies
##################
data "aws_iam_policy" "ssm" {
  name   = "ssm-global-policy"            
}


data "aws_iam_policy_document" "flow_log_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    effect = "Allow"
    sid    = ""
  }
}

data "aws_iam_policy_document" "flow_log_policy" {
  statement {
    actions = ["logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
    "logs:DescribeLogStreams"]
    effect    = "Allow"
    resources = ["*"]
  }
}
