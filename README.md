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

#### S3 Naming Rules

- Must be between 3-63 characters long
- Must contain only lowercase letters, numbers, hyphens, and underscores
- Must start and end with a letter or number
- Must not contain spaces
- Must not contain uppercase letters
- Must not contain special characters
- Must not contain consecutive periods
- Must not start with `xn--`, `sthree-`, or `sthree-configuration` prefix
- Must not end with `s3outpost` suffix
- Must not be formatted as IP address
- Must begin and end with a letter
- Must not end with `--s3alias` or `--ol-s3`
- Must be unique across all AWS accounts
- Cannot ne reused unless original bucket is deleted

#### S3 Bucket Restrictions and Limitations

- Default buckets size is 100 but can be increased to 1000 buckets by requesting.
- Bucket needs to be empty before deletion
- There is no maximum bucket size and objects, files can be between 0-5TB
- Get, Put, List and Delete Ops are designed for HA. 

### Types of S3 Buckets

1. **General Purpose**
   - Organizes data in a flat hierarchy
   - It is the original S3 bucket type
   - Used with all storage classes except with **S3 Express One Zone** Storage class
   - No prefix limits
   - Default liit of 100 general purpose buckets per account

2. **Directory Buckets**
   - Organizes data in folder hierarchy
   - Only used with **S3 Express One Zone** Storage class
   - Recommended for single-digit millisecond performance for PUT and GET Ops.
   - No prefix limits for directory buckets
   - Individual directories can scale horizontally
   - Default limit is 10 directory buckets per account

#### S3 Bucket Folders

S3 Bucket Folders are S3 objects with a name that ends with a forward slash `/`.

### S3 Objects

S3 Objects are resources that represnet data and are not infrastructure resources.
**Properties**
  - **Etags**: a way to detect when the contents of an object have changed without downloading the contents of the object. 
  - **Checksums**: ensures the integrity of files being uploaded to or from S3.
  - **Object Prefixes**: Simulates file-system folders in a flat hierarchy.
  - **Object Metadata**: Describes the contents of the data
  - **Object tags**: Resource tagging but at the object level.
  - **Object Locking**: Makes data files immutable
  - **Object Versioning**: Having multiple versions of a data file

#### S3 Object Etags
A response header that is returned when an object is uploaded to S3. It is a hash of the object contents.
- Uses a hashing function to generate a unique identifier for the object e.g MD5 or SHA-1
- Etags are part of the HTTP protocol
- Etags are used for revalidating in caching systems
- Etags represent a hash of an S3 object
- Etags reflect changes only to the object contents and not metadata
- Etags represent a specific version of an object

#### S3 Object Checksums
Amazon S3 uses checksums to verify data integrity of files on the transfer of data to and from S3.
AWS allows you to chnage the checksum algorithm during the uploading of an object

**Checksum Algorithms**
- **CRC32**: A 32-bit checksum value that is calculated from the object data.
- **CRC32C**: A 32-bit checksum value that is calculated from the object data.
- **SHA1**: A 160-bit checksum value that is calculated from the object data.
- **SHA256**: A 256-bit checksum value that is calculated from the object data.

#### S3 Object Prefixes
These are prefixes that proceed the object filename and is part of the object key name. e.g `assests/images/image.png`. In this case `assets/images` is the prefix.
Object prefixes allows for a way ti organize, group, and filter objects in a bucket.
Prefixes use the forwad slash `/` as a delimiter to group similar data to directories, or subdirectories.

#### S3 Object Metadata
Metadata provides information about other data but not the contents itself.
Metadata is used for;
- Categorization and organization of data
- Providing context about the data
- S3 allows you to attach metadata to S3 objects at anytime

1. **System Defined Metadata**

This is metadata that only Amazon can control. i.e
   - `Content-Type`
   - `Content-Encoding`
   - `Content-Language`
   - `Cache-Control`
   - `Expires`
   - `x-amz-website-redirect-location:/new-page.html`
2. **User Defined Metadata**

User-defined metadata is metadata that is set by the user and must start with `x-amz-meta-`.
   - `x-amz-meta-encryption:"AES-256"`
   - `x-amz-meta-access-level:"confidential"`
   - `x-amz-expiration-date:"2026-12-31"`

#### WORM in the Cloud
Write Once Read Many (WORM) is a storage compliance feature that makes data immutable. You write once and the file can never be modified or deleted, but can be read an unlimited number of times.

#### S3 Object Lock
S3 Object Lock is a feature that allows you to prevent objects from being deleted or overwritten for a fixed amount of time.
  - Data Ingerity
  - Regulatory Compliance

S3 Object Lock is an SEC 17a-4, CTCC, and FINRA regulatory compliance feature. For S3 Object locking, objects are stored using a WORM model, just like in S3 Glacier.
S3 Object Locking can be used to prevent objects from being deleted or overwritten for;
  - A fixed amount of time
  - Indefinitely

Object retention is handled in two different ways:
  - **Retention Periods**: fixed period of time during which objects are protected from deletion or overwrite.
  - **Legal Holds**: A hold placed on an object that prevents it from being deleted or overwritten. Legal holds can be placed on objects indefinitely and can be removed at any time.

S3 Object Locking can only be set via the AWS API. i.e (CLI,SDK), and not in the AWS Console.

### AWS S3 Bucket URI
The S3 Bucket URI is a way to reference the address of an S3 bucket and S3 objects. The S3 Bucket URI is required for specific AWS CLI commands. e.g.

```bash
s3://my-example-bucket/object-name
```

### AWS S3 CLI
- `aws s3`: a high-level way to interact with S3 buckets and objects. e.g;

  ```bash
  aws-s3 cp hello.txt s3://mybucket/hello.txt
  ```
- `aws s3api`: a low-level way to interact with S3 buckets and objects. e.g:

  ```bash
  aws s3api put-object \
    --bucket mybucket \
    --key hello.txt \
    --body hello.txt
  ```
- `aws s3control`: managing S3 endpoints, S3 outposts, S3 Batch Operations, S3 Inventory, S3 Replication, S3 Storage Lens, and S3 Object Lock.

  ```bash
  aws s3control describe-job \
    --account-id 123456789012 \
    --job-id 93735412-1234-5678-9012-345678901234
  ```
- `aws s3outposts`: manage endpoints for S3 outposts

### S3 Request Styles

Amazon S3 supports two request styles:

1. **Path Style**: The bucket name is in the request path. i.e `http://bucket-name.s3.amazonaws.com/object-name` e.g,
   ```bash
   DELETE/examplebucket/objectname HTTP/1.1
   Host: s3.amazonaws.com
   x-amz-date: Wed, 21 Oct 2015 18:27:50 +0000
   Authorization: AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20151021/us-east-1/s3/aws4_request, SignedHeaders=host;x-amz-date, Signature=b64-encoded-signature
   ```
2. **Virtual Hosted Style**: The bucket name is a subdomain on the host. i.e `http://bucket-name.s3.amazonaws.com/object-name` e.g,
   ```bash
   DELETE/objectname HTTP/1.1
   Host: examplebucket.s3.amazonaws.com
   x-amz-date: Wed, 21 Oct 2015 18:27:50 +0000
   Authorization: AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20151021/us-east-1/s3/aws4_request, SignedHeaders=host;x-amz-date, Signature=b64-encoded-signature
   ```
S3 supports both Virtual-hosted and path-style requests. However, Virtual-hosted style is the recommended way to access S3 buckets and objects since path-style URIs will be discontinued in the future.
To force AWS CLI to use virtual-hosted style requests, you need to globally configure the CLI. e.g, 
```bash
aws configure set s3.addressing_style virtual
```

### S3 Dualstack Endpoints
There are two possible endpoints when accessing the Amazon S3 API:

1. **Standard Endpoint**: Handles IPv4 traffic e.g.

   ```bash
   https://s3.us-east-1.amazonaws.com
   ```
2. **Dualstack Endpoint**: Handles both IPv4 and IPv6 traffic e.g.

   ```bash
   https://s3.dualstack.us-east-1.amazonaws.com
   ```

At one point, AWS only supported IPv4 traffic. However, with the deprecation of IPv4, AWS introduced dualstack endpoints to support both IPv4 and IPv6 traffic.

### S3 Storage Classes

AWS offers a range of S3 storage classes that trade retrieval time, accessibility and durability for cheaper storage costs.

#### S3 Standard Storage Class

S3 Standard is the default storage class for S3 buckets. It is a general-purpose storage class that is suitable for a wide range of use cases.

It is desgined for general purpose storage for frequently accessed data.

**Properties**

- High Durability: 99.999999999% (11 nines)
- High Availability: 99.99% (4 nines)
- Data Redundancy: Data is stored across 3 or more AZs.
- Retrieval Time: Milliseconds
- Higher throughput: optimized for data that is frequently accessed and/or requires real time access.
- Scalability: Easily scales to storage size and number of requests.
- Does not have a Minimum Storage Duration Charge.
- Is has no retrieval fees.
- Pricing is per GB per requests.

#### S3 Reduced Redundancy Storage (RRS)
S3 RRS is a legacy storage class to store non-critical, reproducible data at lower levels of redundancy than AWS S3's standard storage. RRS currently provides no cost-benefit to customers on AWS for the reduced redundancy and has no place in modern storage use-cases.

RRS is no longer cost-effectice, and is not recommended for use. It is only still available in the AWS Console as an option due to legacy customers.


### S3 Batch Operations
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