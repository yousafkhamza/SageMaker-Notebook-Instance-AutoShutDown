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