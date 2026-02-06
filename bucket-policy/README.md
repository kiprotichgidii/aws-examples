## Create a bucket

```bash
aws s3 mb s3://bucket-policy-gidi
```
## Create bucket policy

```bash
aws s3api put-bucket-policy --bucket bucket-policy-gidi --policy file://bucket-policy.json
```
# In the other account access the bucket

```bash
touch bootcamp.txt
aws s3 cp bootcamp.txt s3://bucket-policy-gidi
aws s3 ls s3://bucket-policy-gidi
```

## Cleanup

```bash
aws s3 rm s3://bucket-policy-gidi/bootcamp.txt
aws s3 rb s3://bucket-policy-gidi
```