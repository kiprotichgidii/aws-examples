## The Pillars of Observability

**Observability** is the ability to measure and understand how internal systems work, in order to answer questions regarding performance, tolerance, security, and faults within a system or application.

To obtain observability, you need to use Metrics, Logs, and Traces. Using them together will provide you with a comprehensive view of your system's health and performance.

1. **Metrics**
   - Metrics are numerical values that represent the state of a system at a particular point in time.

2. **Logs**
   - Logs are records of events that occur within a system at a particular point in time.

3. **Traces**
   - Traces are records of requests that flow through a system/app/service that pinpoint performance or failures.

![Observability](./images/aws-pillars-of-observability.png)

**Alarms** is sometimes referred to as the fourth pillar of observability.

## AWS CloudWatch

**AWS CloudWatch** is a monitoring and observability service that provides visibility into the performance and health of AWS resources and applications running on AWS. It collects and tracks metrics, collects and monitors log files, and sets alarms and responds to changes in your AWS resources.

**CloudWatch** is really just an umbrella service, meaning that it's a collection of monitoring tools as follows:

1. **Logs**
   - Any custom log data
   - Application logs, Nginx logs, Lambda Logs, etc
2. **Metrics**
   - Represents a time series of data points.
   - A variable to monitor, eg. CPU Utilization, Memory Usage, etc
3. **Events**
   - Triggered by a specific action or condition.
   - eg. Take a snapshot of the server every hour(known as Amazon EventBridge)
4. **Alarms**
   - Triggers notifications based on metrics which breach a defined threshold.
5. **Dashboards**
   - Visualize metrics and logs in a single view.
6. **ServiceLens**
   - Visualize and analyze the health, performance, and availability of your applications and services in a single place.
7. **Container Insights**
   - Collects, aggregates, and summarizes metrics and logs from your containerized applications and microservices running on AWS or on-premises.
8. **Synthetics**
   - Test your web applications and APIs for performance and availability.
9. **Contributor Insights**
   - View the top contributors impacting system and application performance in real-time.

CloudWatch Logs is the basis for many CloudWatch services.

![CloudWatch](./images/aws-cloudwatch-logs.png)

### CloudWatch Logs

**CloudWatch Logs** is a centralized log management service used to monitor, store, and access log data from applications, services, and devices. 

- CloudWatch Logs can be exported to **S3** for tasks such as custom analysis, long-term storage, and backup.
- CloudWatch Logs can be streamed to an **Elasticsearch** cluster in real-time to have more robust full-text search capabilities or use with the ELK Stack.
- **CloudTrail** can be turned on to stream event data to a CloudWatch Log Group.
- By default, log groups are encrypted at rest using **SSE** but users can use their own Customer Master Keys (CMKs) with AWS KMS.
- CloudWatch Logs can be filtered using a Filtering Syntax and CloudWatch Logs has a sub-service called **CloudWatch Insights**.
- By default, Logs are **kept indefinitely and never expire**, but the retention policy can be adjusted for each log group.
  - keeping the indefinite retention
  - choosing a retention period between 1 Day - 10 years

Most AWS Services are integrated with CloudWatch Logs. Logging of services ***sometimes needs to be turned** on or requires the IAM Permission to CloudWatch Logs.

### CloudWatch Log Groups

**Log Groups** are a collection of log streams. It's very common to name log groups with a forward slash syntax:

- `/aws/example/prod/app`
- `/aws/example/prod/db`
- `/aws/example/dev/app`
- `/aws/example/dev/db`

![CloudWatchLog Groups](./images/aws-cloudwatch-log-groups.png)

### CloudWatch Log Streams

