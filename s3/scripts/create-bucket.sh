#!/usr/bin/env bash
echo "Creating bucket: $1"

# Check if the bucket name is provided
if [ -z "$1" ]; then
    echo "You must specify a bucket name: e.g, ./create-bucket my-example-bucket"
    exit 1
fi

BUCKET_NAME=$1
REGION=${2:-"us-east-1"}

if [ "$REGION" == "us-east-1" ]; then
  aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION \
    --query 'Location' \
    --output text
else
  aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION \
    --create-bucket-configuration="LocationConstraint=$REGION" \
    --query 'Location' \
    --output text
fi