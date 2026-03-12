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

