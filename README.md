# SageMaker Instance AutoShutDown with Python and Terraform

[![Build](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

---
## Description
This is a terraform script and it includes a python script that we can use to shutdown sagemaker notebook instances using the lambda function with tags. Also, terraform creates a cloudwatch trigger for lambda, and which that time you can assign whenever you want.

Furthermore, if you have a sagemaker notebook instance please add a tag like "AutoStop: True". Please note that the lambda python script works with the tag so please add the same from yourself on your existing sagemaker notebook instances.

----
## Feature
- Save Money (SageMaker instances are too costly.)
- Automated with CloudWatch Event Rule
- SageMaker Shutdown with tags feature.

----
## Architecture
![alt text](https://i.ibb.co/tXS81cJ/flow.jpg)

----
## Services Created

- IAM Role (Custom Inline Policies for lambda)
- Lambda Function (Python for SageMaker ShutDown)
- Cloudwatch Event Rule Trigger

----
## Pre-Requests
- Terraform (Configure your machine with AWS Creds with the above service access)
- Git
- Please add tag (Key: AutoStop, Value: True)
![alt text](https://i.ibb.co/fvHY48f/Screenshot-7.png)

#### Terraform Installation
[Terraform Installation from official](https://www.terraform.io/downloads)

_TFSwitch Installation:_
```
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
```

#### Pre-Requests (for RedHat-based-Linux)
```
yum install -y git
```

#### Pre-Requests (for Debian-based-Linux)
````
apt install -y git
````

#### Pre-Requests (for Termux-based-Linux)
````
pkg upgrade
pkg install git
````

---
## How to Get
```
git clone https://github.com/yousafkhamza/SageMaker-Notebook-Instance-AutoShutDown.git
cd SageMaker-Notebook-Instance-AutoShutDown
```

----
## How to execute
```
terraform init
terraform plan
terraform apply
```

----
## Output be like
```
$terraform apply --auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # aws_cloudwatch_event_rule.trigger_to_stop_sagemaker_instance will be created
  + resource "aws_cloudwatch_event_rule" "trigger_to_stop_sagemaker_instance" {
      + arn                 = (known after apply)
      + description         = "Trigger that moving data lambda"
      + event_bus_name      = "default"
      + id                  = (known after apply)
      + is_enabled          = true
      + name                = "Trigger-stop-sagemaker-instance-lambda"
      + name_prefix         = (known after apply)
      + schedule_expression = "cron(0 16 * * ? *)"
      + tags                = {
          + "Name" = "sagemaker stop cloudwatch trigger"
        }
      + tags_all            = {
          + "Name" = "sagemaker stop cloudwatch trigger"
        }
    }

  # aws_cloudwatch_event_target.send_to_stop_lambda_target will be created
  + resource "aws_cloudwatch_event_target" "send_to_stop_lambda_target" {
      + arn            = (known after apply)
      + event_bus_name = "default"
      + id             = (known after apply)
      + rule           = "Trigger-stop-sagemaker-instance-lambda"
      + target_id      = "SendToLambda"
    }

  # aws_iam_role.lambda_iam_role_terraform will be created
  + resource "aws_iam_role" "lambda_iam_role_terraform" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "lambda.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + description           = "IAM role for lambda to stop that SageMaker instance which we used tags AutoStop"
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "Lambda-IAM-Role-For-SageMaker-Auto-ShutDown"
      + name_prefix           = (known after apply)
      + path                  = "/lambda/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = "SageMaker-Auto-ShutDown-Inline-Policy"
          + policy = jsonencode(
                {
                  + Statement = [
                      + {
                          + Action   = [
                              + "sagemaker:StopNotebookInstance",
                              + "sagemaker:ListTags",
                              + "sagemaker:DescribeNotebookInstance",
                              + "sagemaker:AddTags",
                            ]
                          + Effect   = "Allow"
                          + Resource = "arn:aws:sagemaker:ap-south-1:514645378310:notebook-instance/*"
                          + Sid      = ""
                        },
                      + {
                          + Action   = "sagemaker:ListNotebookInstances"
                          + Effect   = "Allow"
                          + Resource = "*"
                          + Sid      = ""
                        },
                    ]
                  + Version   = "2012-10-17"
                }
            )
        }
    }

  # aws_lambda_function.sagemaker_stop_lambda_function will be created
  + resource "aws_lambda_function" "sagemaker_stop_lambda_function" {
      + architectures                  = (known after apply)
      + arn                            = (known after apply)
      + description                    = "This lambda using to stop the sagemaker instance which we mentioned"
      + filename                       = "tmp/stop-lambda-function.zip"
      + function_name                  = "sagemaker-stop-lambda-function"
      + handler                        = "lambda_function.lambda_handler"
      + id                             = (known after apply)
      + invoke_arn                     = (known after apply)
      + last_modified                  = (known after apply)
      + memory_size                    = 128
      + package_type                   = "Zip"
      + publish                        = false
      + qualified_arn                  = (known after apply)
      + reserved_concurrent_executions = -1
      + role                           = (known after apply)
      + runtime                        = "python3.9"
      + signing_job_arn                = (known after apply)
      + signing_profile_version_arn    = (known after apply)
      + source_code_hash               = (known after apply)
      + source_code_size               = (known after apply)
      + tags                           = {
          + "Name" = "sagemaker stop lambda function"
        }
      + tags_all                       = {
          + "Name" = "sagemaker stop lambda function"
        }
      + timeout                        = 60
      + version                        = (known after apply)

      + environment {
          + variables = {
              + "REGION" = "ap-south-1"
            }
        }

      + ephemeral_storage {
          + size = (known after apply)
        }

      + tracing_config {
          + mode = (known after apply)
        }
    }

  # aws_lambda_permission.allow_cloudwatch_to_call_stop_lambda will be created
  + resource "aws_lambda_permission" "allow_cloudwatch_to_call_stop_lambda" {
      + action              = "lambda:InvokeFunction"
      + function_name       = "sagemaker-stop-lambda-function"
      + id                  = (known after apply)
      + principal           = "events.amazonaws.com"
      + source_arn          = (known after apply)
      + statement_id        = "AllowExecutionFromCloudWatch"
      + statement_id_prefix = (known after apply)
    }

Plan: 5 to add, 0 to change, 0 to destroy.
aws_iam_role.lambda_iam_role_terraform: Creating...
aws_iam_role.lambda_iam_role_terraform: Creation complete after 4s [id=Lambda-IAM-Role-For-SageMaker-Auto-ShutDown]
aws_lambda_function.sagemaker_stop_lambda_function: Creating...
aws_lambda_function.sagemaker_stop_lambda_function: Still creating... [10s elapsed]
aws_lambda_function.sagemaker_stop_lambda_function: Still creating... [20s elapsed]
aws_lambda_function.sagemaker_stop_lambda_function: Creation complete after 22s [id=sagemaker-stop-lambda-function]
aws_cloudwatch_event_rule.trigger_to_stop_sagemaker_instance: Creating...
aws_cloudwatch_event_rule.trigger_to_stop_sagemaker_instance: Creation complete after 1s [id=Trigger-stop-sagemaker-instance-lambda]
aws_lambda_permission.allow_cloudwatch_to_call_stop_lambda: Creating...
aws_cloudwatch_event_target.send_to_stop_lambda_target: Creating...
aws_cloudwatch_event_target.send_to_stop_lambda_target: Creation complete after 0s [id=Trigger-stop-sagemaker-instance-lambda-SendToLambda]
aws_lambda_permission.allow_cloudwatch_to_call_stop_lambda: Creation complete after 0s [id=AllowExecutionFromCloudWatch]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```
### _Output Screenshots (at AWS)_
![alt text](https://i.ibb.co/vPp6Csq/Screenshot-8.png)

----
## Behind the code
### Terraform code
`Fetch.tf`:
```
# Fetch Account ID for IAM.
data "aws_caller_identity" "current" {
}
```
> File used to fetch current account id and the account used to secure IAM role creation for lambda

`IAM.tf`:
```
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

# Inline policy for sagemaker stop for lambda
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
```
> Creating IAM role with SageMaker Shutdown and tag describing privilege for lambda function execution

`Lambda_Stop.tf`:
```
# ----------------------------------
# Lambda_Function
# ----------------------------------
#archiving py file to zipping
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
```
> will create a lambda function with the python code. also, create a cloudwatch trigger with your time and set up target with the same lambda as we created the same. 

`provider.tf`:
```
provider "aws" {
region = var.aws_region
}
```
> which region do you want? 

`variables.tf`:
```
variable "aws_region" {
  type        = string
  description = "Which region do you use"
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
```
> variables creation and values are stored in tfvars file

`terraform.tfvars`:
```
aws_region = "ap-south-1"            # mention which region you need here.
stop_cron = "cron(0 16 * * ? *)"     # Which time to stop that SageMaker instance here.
```
> Mention your region and lambda cloudwatch event trigger cron time

`versions.tf`:
```
terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = ">= 3.36"
  }
}
```
> Supported versions with terraform

`lambda_function.py`:
```
import boto3
from botocore.exceptions import ClientError
import os

REGION = os.environ['REGION']

def lambda_handler(event, context):
    client = boto3.client('sagemaker', region_name=REGION)
    response = client.list_notebook_instances(MaxResults=100)
    notebooks = response['NotebookInstances']
    notebook_list = []
    for notebook in notebooks:
        notebook_dict = dict()
        notebook_dict['NotebookInstanceName'] = notebook['NotebookInstanceName']
        notebook_dict['NotebookInstanceArn'] = notebook['NotebookInstanceArn']
        notebook_dict['NotebookInstanceStatus'] = notebook['NotebookInstanceStatus']
        notebook_dict['InstanceType'] = notebook['InstanceType']
        notebook_list.append(notebook_dict)

    for InstanceName in notebook_list:
        InstanceSName=InstanceName['NotebookInstanceName']
        DescribeInstance = client.describe_notebook_instance(
        NotebookInstanceName=f'{InstanceSName}')
        InstanceArn=DescribeInstance['NotebookInstanceArn']
        Tags=client.list_tags(
        ResourceArn=f'{InstanceArn}')
        if len(Tags['Tags']) != 0:
            if Tags['Tags'][0]['Key'] == "AutoStop" and Tags['Tags'][0]['Value'] == 'True':
                    if DescribeInstance['NotebookInstanceStatus'] == 'InService':
                        try:
                            print("Stopping SageMaker Instance : {}".format(InstanceSName))
                            response = client.stop_notebook_instance(NotebookInstanceName=f'{InstanceSName}')
                        except ClientError as e:
                            print(e.response['Error']['Message'])
```
> lambda function code with sagemaker instance shutdown and please note that we are using tags AutoStop. So, if you need to change please change inside the code

----
## Conclusion
SageMaker Notebook instances are costly. So, if you forget to shut down an instance and get more bills then you can use the terraform script and deploy the same to your aws account and add the tags to your existing instances then this will help you to shut down a particular time daily. Please note that you may start the instance yourself that couldn't be included in the script.

### ⚙️ Connect with Me 

<p align="center">
<a href="mailto:yousaf.k.hamza@gmail.com"><img src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white"/></a>
<a href="https://www.linkedin.com/in/yousafkhamza"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"/></a> 
<a href="https://www.instagram.com/yousafkhamza"><img src="https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white"/></a>
<a href="https://wa.me/%2B917736720639?text=This%20message%20from%20GitHub."><img src="https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white"/></a><br />
