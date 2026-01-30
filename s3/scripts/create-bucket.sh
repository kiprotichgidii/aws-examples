#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "You must specify a bucket name: e.g, ./create-bucket my-example-bucket"
    exit 1
fi

BUCKET_NAME=$1
REGION=$2

aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION