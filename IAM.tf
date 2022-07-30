# ----------------------------------
# IAM Role for Lambda Function 
# ----------------------------------
# Assume Role - For Lambda
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    actions = [
    "sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
      "lambda.amazonaws.com"]
    }
  }
}

# Inline policy for sagemaker stop start for lambda
data "aws_iam_policy_document" "auto_shutdown_iam_inline" {
  statement {
    actions = [
        "sagemaker:ListTags",
        "sagemaker:StopNotebookInstance",
        "sagemaker:DescribeNotebookInstance",
        "sagemaker:AddTags"
    ]
    resources = [
        "arn:aws:sagemaker:${var.aws_region}:${data.aws_caller_identity.current.account_id}:notebook-instance/*",
    ]
  }
  statement {
    actions = [
        "sagemaker:ListNotebookInstances",
    ]
    resources = [
        "*",
    ]
  }
}



# Role for Lambda and both assume and inline integrated 
resource "aws_iam_role" "lambda_iam_role_terraform" {
  name               = "Lambda-IAM-Role-For-SageMaker-Auto-ShutDown"
  path               = "/lambda/"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  description = "IAM role for lambda to stop that SageMaker instance which we used tags AutoStop"

  inline_policy {
    name   = "SageMaker-Auto-ShutDown-Inline-Policy"
    policy = data.aws_iam_policy_document.auto_shutdown_iam_inline.json
  }
}
