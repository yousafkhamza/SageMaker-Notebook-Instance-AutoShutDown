variable "aws_region" {
  type        = string
  description = "Which region do you used"
  default     = ""
}

variable "stop_cron" {
  type        = string
  description = "Cron time stop the instance which we created"
  default     = "cron(0 17 * * ? *)"
}

locals {
stop_lambda_function = "stop-lambda-function"
runtime_lambda_function = "python3.9"
}
