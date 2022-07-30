# ----------------------------------
# Lambda_Function
# ----------------------------------
#archiving py file to zip
data "archive_file" "stop_lambda_zip" {
  type        = "zip"
  source_dir  = "./lambda_code/stop/"
  output_path = "tmp/${local.stop_lambda_function}.zip"
}

resource "aws_lambda_function" "sagemaker_stop_lambda_function" {
  filename      = data.archive_file.stop_lambda_zip.output_path
  function_name = "sagemaker-stop-lambda-function"
  role          = aws_iam_role.lambda_iam_role_terraform.arn
  description   = "This lambda using to stop the sagemaker instance which we used AutoStop tag"
  handler       = "lambda_function.lambda_handler"
  runtime       = local.runtime_lambda_function
  timeout       = 60
  memory_size   = 128

  environment {
    variables = {
      REGION = var.aws_region
    }
  }

  tags = tomap({"Name" = "sagemaker stop lambda function"})
}


#-----------------------
# CloudWatch Trigger to stop sagemaker instance
#-----------------------
resource "aws_cloudwatch_event_rule" "trigger_to_stop_sagemaker_instance" {
  name                  = "Trigger-stop-sagemaker-instance-lambda"
  description           = "Trigger that moving data lambda"
  schedule_expression   = var.stop_cron
  tags = tomap({"Name" = "sagemaker stop cloudwatch trigger"})

  depends_on = [aws_lambda_function.sagemaker_stop_lambda_function]
}

resource "aws_cloudwatch_event_target" "send_to_stop_lambda_target" {
  rule      = aws_cloudwatch_event_rule.trigger_to_stop_sagemaker_instance.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.sagemaker_stop_lambda_function.arn

  depends_on = [aws_lambda_function.sagemaker_stop_lambda_function]
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_stop_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.sagemaker_stop_lambda_function.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.trigger_to_stop_sagemaker_instance.arn

    depends_on = [aws_lambda_function.sagemaker_stop_lambda_function,aws_cloudwatch_event_rule.trigger_to_stop_sagemaker_instance]
}
