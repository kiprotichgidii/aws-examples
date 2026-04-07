## Elastic Container Registry (ECR)

**Amazon Elastic Container Registry (ECR)** is a fully managed, high-performance Docker container registry provided by AWS. It enables developers to securely store, manage, and 
deploy container images, integrating seamlessly with Amazon EKS, ECS, and CI/CD tools. ECR supports both private and public repositories, automatically scaling infrastructure 
and offering features like vulnerability scanning.

- **ECR** lets you store Docker and Open Container Initiative (OCI) images and artifacts.
- Allows users to control private registry access via Register policy.
- Allows users control private repo access via Repo policy.
- Allows users to scan images on push to identify software vulnerabilities.
- Private image replication allows users to have cross-account and cross-region images.
- ECR allows you to create a Pull Through Cache to sync the contents of an upstream public registry.
- Repo images are encrypted at-rest.
- Amazon ECR lifecycle allows users to manage and automate cleaning up of container images.
- Images can be signed using the AWS Signer to ensure images are from trusted developers.
- Tags can be set to mutable or immutable.

![Amazon ECR](./images/ecr-ecs-eks.png)

- A registry contains multiple repos
- A repo contains multiple images
- An image can have multiple tags
- A tag points to a specific image version
  - eg. 1.0, latest

ECR Supports
 - **Public registries**: accessible to anyone
 - **Private registries**: only accessible to those within the AWS account
   - Control access via **Register Policy**
     - `ecr:ReplicateImage`
     - `ecr:BatchImportUpstreamImage`
     - `ecr:CreateRepository`
   - Control Access via **Repo Policy**
     - `ecr:DescribeImages`
     - `ecr:DescribeRepositories`

To push to ECR, you must first authenicate using docker with an authorization token. To obtain this token, you need to have AWS credentials configured in your environment:

```sh
# Login to ECR
aws ecr get-login-password \
  --region us-east-1 \ |
  docker login \
    --username AWS \
    --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com

# Build, tag  and Push Image
docker buildx build -f Dockerfile \
  --platform linux/amd64,linux/arm64,linux/386,linux/ppc64le,linux/s390x \
  -t "<aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-image:latest" \
  --push .
```

Image tag mutability feature prevents image tags from being overwritten. To turn it on:

```sh
aws ecr create-repository \
  --repository-name my-repo \
  --image-tag-mutability IMMUTABLE \
  --region us-east-1
```

When tag immutability is turned on for a repository, this affects all tags, you cannot make some tags immutable and others mutable. Immutable tags is a best practice because if 
there was a security vulnerability with a specific image, you can rollbackto the previous image ore preserve the history of vulnerabilities.

The `ImageTagAlreadyExistsExceptio` error is returned if you attempt to push an image with a tag that is already in the repository.

ECR lifecycle can be used to expire old images based on specific criteria:

```json
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 30 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPatternList": ["prod*"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
```

