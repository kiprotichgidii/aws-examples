## Create a new bucket

```sh
aws s3api create-bucket --bucket gidii-acl-example-bucket --region us-east-1
```

## Turn of Block Public Access for ACLs

```sh
aws s3api put-public-access-block \
  --bucket gidii-acl-example-bucket \
  --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

```sh
aws s3api get-public-access-block --bucket gidii-acl-example-bucket
```

## Change Bucket Ownership


```sh
aws s3api put-bucket-ownership-controls \
  --bucket gidii-acl-example-bucket \
  --ownership-controls="Rules=[{ObjectOwnership=BucketOwnerPreferred}]"
```

## Change ACLs to allow for a user in another AWS Account

```sh
aws s3api put-bucket-acl \
  --bucket gidii-acl-example-bucket \
  --access-control-policy file:///Users/gedeon/Dev/aws-examples/acls/policy.json
```

## Access Bucket from other account

```sh
touch bootcamp.txt
aws s3 cp bootcamp.txt s3://gidii-acl-example-bucket
aws s3 ls s3://gidii-acl-example-bucket
```

## Cleanup

```sh
aws s3 rm s3://gidii-acl-example-bucket/bootcamp.txt
aws s3 rb s3://gidii-acl-example-bucket
```