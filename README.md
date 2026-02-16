# AWS Solutions Architect(SAA-C03) Exam Prep
The AWS Solutions Architect - Associate (SAA-C03) is a mid-level certification exam that validates a candidate's ability to design secure, resilient, high-performing, and cost-optimized solutions on AWS.
It is highly recognized as one of the most valuable cloud certification for IT professionals like solutions architects, cloud engineers, and DevOps engineers.

### Exam Overview
- Format: 65 Questions
- Duration: 130 Minutes
- Cost: $150 USD
- Passing Score: 720 out of 1000(72%)
- Valifity: 3 Years

### Exam Domains and Weighting
The exam focuses on four key areas of the AWS Well-Architected Framework:
1. Design Secure Architectures(30%): Identity management (IAM), data protection (encryption with KMS), and network security (VPCs, Security Groups).
2. Design Resilient Architectures(26%): High availability, fault tolerance, and disaster recovery using Multi-AZ deployments, Auto Scaling, and Route 53.
3. Design High-Performing Architectures (24%): Selecting optimized compute (EC2), database (RDS, DynamoDB), and storage (S3, EBS) for performance efficiency.
4. Design Cost-Optimized Architectures (20%): Right-sizing resources, using Savings Plans/Reserved Instances, and monitoring costs with AWS Cost Explorer.


## Amazon S3(Simple Storage Service)

S3 bucket names are used to form URL links to perform various HTTPS operations i.e `https://myexamplebucketname.s3.amazonaws.com/object-name`.

#### S3 Batch Operations
S3 Batch Operations allows you to perform large-scale batch operations on S3 objects. You can use S3 Batch Operations to perform operations such as copying objects, updating object metadata, and deleting objects.

Batch Operations:
- **Copy**: Copy objects listed in the manifest to the specified destination bucket.
- **Invoke AWS Lambda Function**: Run a Lambda function for each object in the manifest.
- **Replace Object Tags**: Replace the tags on Amazon S3 objects listed in the manifest.
- **Replcae ACLs**: Replace ACLs on Amazon S3 objects listed in the manifest.
- **Restore Objects**: Restore objects from S3 Glacier.
- **Object Lock Retention**: Prevents Overwriting or Deleting objects for a fixed amount of time.
- **Object Lock Legal Hold**: Prevents Overwriting or Deleting objects until the legal hold is removed.

In order to use S3 Batch Operations, you need to provide lists of objects in an S3 or supply an S3 inventory report `manifest.json`.

You can also have Batch Operations generate out a completion report to audit the outcome of bulk operations.

### Amazon S3 Inventory

Amazon S3 Inventory takes inventory of objects in an S3 bucket on a repeated schedule so that you have an audit history of object changes.

Amazon S3 will outout the inventory into the destination of another S3 bucket in the form of a manifest file.

You can specify additional metadata to be included in the inventory report such as:
- Object size
- Last modified date
- Storage class
- Object tags
- Object ACLs
- Object retention
- Object legal hold
- Object encryption status

#### Frequency
- Daily: delivered within 48 hours
- Weekly: First report delivered within 48 hrs, full reports every Sunday.

#### Output Format
- CSV (Comma Separated Values)
- ORC (Optimized Row Columnar)
- Parquet (Columnar Storage File Format) Apache Parquet

#### Inventory Scope
- Specific prefixes to filter objects
- Specific all or only current version