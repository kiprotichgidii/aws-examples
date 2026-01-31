#!/usr/bin/env bash

echo "Putting object: $1"

# Check if the bucket name is provided
if [ -z "$1" ]; then
    echo "You must specify a bucket name: e.g, ./put-object my-bucket-name"
    exit 1
fi

# Check if the file name is provided
if [ -z "$2" ]; then
    echo "There needs to be a filename: eg, ./bucket my-bucket-name filename"
    exit 1
fi

BUCKET_NAME=$1
FILE_NAME=$2
OBJECT_KEY=$(basename "$FILE_NAME")

aws s3api put-object \
  --bucket $BUCKET_NAME \
  --key "$OBJECT_KEY" \
  --body "$FILE_NAME" \
  --query 'Location' \
  --output text
