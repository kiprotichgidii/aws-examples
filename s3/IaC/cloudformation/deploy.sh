#!/usr/bin/env bash

echo "Creating S3 bucket using CloudFormation"

STACK_NAME="amzn-s3-stack"

aws cloudformation deploy \
  --template-file ~/Dev/aws-examples/s3/IaC/cloudformation/template.yaml \
  --stack-name $STACK_NAME \
  --no-execute-changeset \
  --region ca-central-1 \
  --capabilities CAPABILITY_IAM