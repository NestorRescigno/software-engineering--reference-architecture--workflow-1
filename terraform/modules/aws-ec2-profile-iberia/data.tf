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

data "aws_iam_policy" "SSMServiceRolePolicy" {
    arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonSSMServiceRolePolicy"
}