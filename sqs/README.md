## Amazon Simple Queueing Service (SQS)

**Simple Queueing Service (SQS)** is a fully managed message queuing service that enables you to decouple and scale microservices, distributed systems, and serverless applications.

![Simple Queueing Service](./images/aws-sqs.png)

**Use Case**

When a user needs to queue up transaction emails to be sent. e.g. Sign-up, Password Reset, Order Confirmation.

#### SQS Queue Types

1. **Standard Queue**: Allows users to process a nearly unlimited number of messages, but messages are not in order.
2. **FIFO Queue**: Allows users to process a certain number of messages, but messages are in order and there are no duplicates.

#### SQS Message Size

SQS Messages can be between 1KB and 256KB. For large messages, a Library is required.

#### Message Retention

This is how long SQS will hold onto a message in the queue before dropping (deleting) it. By default, messages in the queue are held for 4 days. Message retention can be adjusted from a minimum of 60 seconds to a maximum of 14 days.

#### Queue Encryption

SQS queues can be encrypted using Amazon Managed Server-Side Encryption or KMS. This ensures that messages in the queue are encrypted at rest and in transit.

#### Use Case

1. App publishes messages to the queue
2. Another app pulls the queue and finds the message in the queue and does something with it
3. Another app reports that they completed their task and marks the message for completion
4. Original app pulls the queue and finds that the message is no longer in the queue

In this scenario, both apps are using the AWS SDK to interact with the SQS queue for push and pull operations.

### Sending Large Messages

To send large messages to SQS, these libraries can be used:

- Amazon SQS Extended Client Library for Java/Python.
  - https://github.com/awslas/amazon-sqs-python-extended-client-lib

![SQS Large Messages](./images/aws-sqs-sending-large-messages.png)

These libraries are useful for messages that are larger than the current maximum of 256KB, with a maximum of 2GB. Both libraries save the actual payload to an S3 bucket, and publish the reference of the stored S3 object to the SNS topic. 

#### Python Example

```python
import boto3
import sns_extended_client

sns = boto3.client('sns')
sns.large_payload_support = 'bucket_name'

# boto SNS topic resource
resource = boto3.resource('sns')
topic = resource.Topic('topic-arn')
platform_endpoint = resource.PlatformEndpoint('endpoint-arn')
platform_endpoint.large_payload_support = 'my_bucket_name'

# To keep it enabled at all times
platform_endpoint.always_through_s3 = True

# Publish the Large Message
sns.publish(
    Message="message",
    MessageAttribute = {
        "S3Key": {
            "DataType": "String",
            "StringValue": "--S3--Key--",
        }
    },
)
```