#!/usr/bin/env bash

echo "Deleting S3 bucket using CloudFormation"

STACK_NAME="amzn-s3-stack"

aws cloudformation delete-stack \
  --stack-name $STACK_NAME \
  --region ca-central-1