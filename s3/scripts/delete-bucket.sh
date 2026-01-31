#!/usr/bin/env bash
echo "Deleting bucket: $1"

# Check if the bucket name is provided
if [ -z "$1" ]; then
    echo "You must specify a bucket name: e.g, ./delete-bucket my-example-bucket"
    exit 1
fi

BUCKET_NAME=$1

aws s3api delete-bucket \
  --bucket $BUCKET_NAME 