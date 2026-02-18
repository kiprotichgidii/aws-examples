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
- Pricing:
  - Storage Per GB
  - Per Request
  - Has no retrieval fee
  - Has no minimum storage duration charge
- Use cases:
  - Content Delivery
  - Dynamic websites
  - Mobile applications
  - Gaming applications
  - Big Data analytics
  - Machine learning
  - Internet of Things (IoT)

#### S3 Reduced Redundancy Storage (RRS)
S3 RRS is a legacy storage class to store non-critical, reproducible data at lower levels of redundancy than AWS S3's standard storage. RRS currently provides no cost-benefit to customers on AWS for the reduced redundancy and has no place in modern storage use-cases.

RRS is no longer cost-effectice, and is not recommended for use. It is only still available in the AWS Console as an option due to legacy customers.

#### S3 Standard-Infrequent Access (S3 Standard-IA)

S3 Standard-IA is a storage class that is designed for data that is less frequently accessed but requires rapid access when needed.

**Properties**

- High Durability: 99.999999999% (11 nines)
- High Availability: 99.9% (3 nines)
- Data Redundancy: Data is stored across 3 or more AZs.
- Retrieval Time: Milliseconds.
- High Throughput: Optimized for rapi access.
- Cost-effective: Costs 50% less than S3 standard, but only if you do not access a file more than once in a month.
- Scalability: Easily scales to storage size and number of requests.
- Pricing:
  - Storage Per GB
  - Per request
  - Has a retrieval fee
  - Has a minimum storage duration charge of 30 days

- Use cases:
  - Disaster Recover storage
  - Backup data storage
  - Long-term data stores

#### S3 Express One Zone Storage Class

Amazon S3 Express One Zone delivers consistent singe-digit millisecond data access for the most frequently accessed data and latency-sensitive applications.

**Properties**

- It is the lowest latency cloud-object storage class available.
- It offers data access speeds upto 10X faster than S3 Standard.
- Requests cost upto 50% less than S3 Standard.
- Data is stored in a single AZ(User selected).
- Data is stored in a new bucket type(Amazon S3 directory bucket).

The S3 directory bucket used supports simple real-folder structure. Only allowed 10 S3 directory buckets per AWS account by default. Express One Zone applies a flat per request charge for requests of upto 512KB.

#### S3 One Zone-IA (Infrequent Access)

S3 One Zone-IS is designed for data that is less frequently accessed and has additional saving at reduced availability.

**Properties**

- High Durability: 99.999999999% (11 nines)
- Lower Availability: Single AZ has lower availability than S3 Standard-IA.
- Cost-effective: One AZ
- Retrieval Time: Milliseconds
- Data Redundancy: Data is stored across a single AZ.
- Retrieval Time: Milliseconds.
- Pricing:
  - Storage Per GB
  - Per request
  - Has a retrieval fee
  - Has a minimum storage duration charge of 30 days

- Use cases:
  - Secondary Backup copies of on-premise data
  - Infrequently accessed non-mission-critical data

#### S3 Glacier Storage Classes vs S3 Glacier Vault

1. **S3 Glacier 'Vault'**

S3 Glacier is a stand-alone service from S3 that uses vaults over buckets to store data long term. S3 Glacier is the original vault service:
  - It has vault control policies
  - Most interactions are via the AWS CLI
  - S3 Glacier is still used by big enterprises for compliance and archival purposes.

S3 Glacier Deep Archive is part of S3 Glacier 'Vault'.

2. **S3 Glacier Storage Class**

S3 Glacier Storage Classes offer simila functionality to S3 Glacier but with greater convenience and flexibility all within AWS S3 buckets.

**S3 Glacier Storage Classes**
  - S3 Glacier Instant Retrieval
  - S3 Glacier Flexible Retrieval
  - S3 Glacier Deep Archive

#### S3 Glacier Instant Retrieval

S3 Glacier Instant Retrieval is a storage class designed for rarely acccessed data that still needs immediate access in performance sensitive use cases.

**Properties**

- High Durability: 99.999999999% (11 Nines)
- High Availability: 99.9% (3 nines)
- Cost-effective: 68% cheaper than S3 Standard -> for long-lived data that is accessed once a quarter.
- Retrieval Time: Milliseconds
- Pricing:
  - Storage Per GB
  - Per request
  - Has a retrieval fee
  - Has a minimum storage duration charge of 30 days

- Use cases:
  - Rarely Accessed data that needs immediate access
  - Image hosting
  - File sharing apps
  - Medical Imaging and health records
  - New media assets
  - Satellite and Aerial imaging

#### S3 Glacier Flexible Retrieval

S3 Glacier Flexible Retrieval combines S3 and Glacier into a single set of APIs. It's considerably faster than Glacier Vault-based storage.

**Retrieval Tiers**

1. **Expedited Tier**: 1-5 minutes, for urgent requests, limited to 250MB archive size.
2. **Standard Tier**: 3-5 hours, no archive size limit 
3. **Bulk Tier**: 5-12 hours, no archive size limit, even Petabytes of data can be retrieved.

Arhived objects will have an additioncal 40KBS of data:
  - 32KB for archive index and metadata
  - 8KB for the name of the object

You pay per GB retrieved and number of requests. This is a separate cost from the cost of storage. It is recommended to store fewer and larger files, instead of smaller files because 40KBs on thousands of files can add up pretty quickly.

#### S3 Glacier Deep Archive

S3 Glacier Deep Archive combines S3 and Glacier into a single set of APIs. It's more cost-effective than S3 Glacier Flexible Retrieval, but with a greater cost of retrieval.

**Retrieval Tiers**

1. **Standard Tier**: 12-48 hours, no archive size limit, default option
2. **Bulk Tier**: 12-48 hours, no archive size limit, even Petabytes worth of data can be retrieved.

Archived objects have an additional 40KBS of data:
  - 32KB for archive index and metadata
  - 8KB for the name of the object

#### S3 Intelligent-Tiering Storage Class

S3 Intelligent-Tiering storage class automatically moves objects into different storage tiers based on access patterns to reduce storage costs. AWS charges a low monthly cost for object monitoring and automation.

**Access Tiers**

1. **Frequent Access Tier**: The default tier, objects remain in there as long as they are being accessed.
2. **Infrequent Access Tier**: Objects are automatically moved into this tier after 30 days of no access.
3. **Archive Instant Access Tier**: Objects are automatically moved into this tier after 90 days of no access.
4. **Archive Access Tier**: After activation, objects are automatically moved into this tier after 90 days of no access.
5. **Deep Archive Access Tier**: After activation, objects are automatically moved into this tier after 180 days of no access.

### S3 Security Overview
1. **Bucket Policies**: Defines permissions for an entire bucket using JSON based access policy langauge.
2. **Access Control Lists (ACLs)**: Provide a legacy method to manage access permissions on individual objects and buckets.
3. **AWS Private Link for Amazon S3**: Enables private network access to S3, bypassing the public internet for enhanced security.
4. **Cross-Origin Resource Sharing (CORS)**: Allows restricted resources on a web page from another domain to be requested.
5. **Amazon S3 Block Public Access**: A collection of settings that work together to prevent unintended public access to S3 buckets and objects.
6. **IAM Access Analyzer for S3**: Analyzes resource policies to help identify and mitigate potential threats.
7. **Internetwork Traffic Privacy**: Ensure data privacy by encrypting data moving between AWS services and the internet.
8. **Object Ownership**: Manages data ownership between AWS accounts when objects are uploaded to S3 buckets.
9. **S3 Access Points**: Simplifies managing data access at scale for shared datasets in S3.
10. **Access Grants**: Providing access to S3 data via a directory service such as AD.
11. **Versioning**: Preserves, retrieves, and restores every version of every object stored in an S3 bucket.
12. **MFA Delete**: Adds an additional layer of security by requiring MFA for deletion of S3 objects.
13. **Object Tags**: Provides a way to categorize storage by assigning key-value pairs to objects.
14. **In-Transit Encryption**: Protects data by encrypting it as it travels to and from S3 over the internet.
15. **Server-Side Encryption**: Automatically encrypt data when writing it to S3 and decrypt it when downloading it. 
16. **Compliance Validation for Amazon S3**: Ensure S3 services meet the compliance requirements like HIPPA, GDPR, etc.
17. **Infrastructure Security**: Protects the underlying infra of the S3 service, ensuring integrity and availability of the service.

#### S3 Block Public Access

Block Public Access is a collection of settings that work together to prevent unintended public access to S3 buckets and objects. It is enabled by default on all new S3 buckets.

Block Public Access settings:
1. **BlockPublicAcls**: Blocks public access to S3 buckets and objects through ACLs.
2. **IgnorePublicAcls**: Ignores public ACLs on S3 buckets and objects.
3. **BlockPublicPolicy**: Blocks public access to S3 buckets and objects through bucket policies.
4. **RestrictPublicBuckets**: Restricts public access to S3 buckets and objects through bucket policies.

#### S3 Access Control Lists (ACLs)

S3 ACLs have been traditionally used to allow other AWS accounts to upload objects to an S3 bucket. It is not recommended to use ACLs for new S3 buckets. Instead, use bucket policies to grant access to other AWS accounts.

ACLs grant basic read/write permissions to other AWS accounts:
- You can grant permissions only to other AWS accounts
- You cannot grant permissions to users in your own AWS account
- You cannot grant conditional permissions
- You cannot explicitly deny permissions

#### S3 Bucket Policies

S3 Bucket policy is a resource-based policy to granrt an S3 bucket and bucket objects to other principles e.g AWS Accounts, Users, AWS Services, etc

#### S3 Bucket Policies vs IAM Policies

S3 bucket policies have overlapping functionality as an IAM policy that grants access to S3.

S3 Bucket policies provide convenience over IAM policies in that they can be used to grant access to S3 buckets and objects without the need to create an IAM policy.

| S3 Bucket Policy | AWS IAM Policy |
| --- | --- |
|Provides access to a specific bucket and it's objetcts | Provides access to many AWS services and resources |
| Can specify multiple principles to grant access to | Can provide permissions for multiple buckets in one policy |
| Bucket policies can be upto 20KB in size | The principle by default is the entity that the IAM policy is attached to|
| Unless Block Public Access is turned off, it will deny all anonymous access even if access is granted using the bucket policy | Policy sizes are limited based on principal: 2KB for users, 5KB for Groups, 10KB for Roles |

#### S3 Access Grants

S3 Access Grants let you map identities in a directory service (IAM Identity Cener, Azure Active Directory, Okta, etc) to access S3 resources.

![](./images/s3-access-grants.png)

#### IAM Access Analyzer for S3

Access Analyzer for S3 will alert you when S3 buckets are expose to the public internet or other AWS accounts.

To utilize Access Analyzer for S3, it needs to be created in the IAM Access Analyzer at the account level.

#### S3 Internet Traffic Privacy

S3 Internet Traffic Privacy ensures data privacy by encrypting data moving between AWS services and the internet. It can be implemented using two different ways:

1. **AWS PrivateLink**
    - Allows you to connect an Elastic Network Interface(ENI) directly to other AWS Services e.g S3,EC2, Lambda, etc.
    - It can connect to select 3rd party services as well via the AWS Marketplace.
    - It can go cross-account.
    - It has fine-grained permissions via VPC endpoint policies.
    - AWS charges a small fee to use PrivateLink.

2. **VPC Gateway Endpoint**
    - Allows you to connect a VPC directly to S3 or (DynamoDB), while staying private within the internal AWS network.
    - VPC Gateway Endpoints do not have the capability to go cross-account.
    - VPC Gateway Endpoints do not have fine-grained permissions.
    - VPC Gateway Endpoints are free of charge.

#### Cross-Origin Resource Sharing (CORS)

CORS is an HTTP-Header based mechanism that allows a server to indicate any other origins (domains,scheme, or port) than it's own from which a browser should permit loading of resources.

Access is controlled via HTTP headers:
1. **Request Header**
   - **Origin**: Specifies the origin of the request.
   - **Access-Control-Request-Method**: Specifies the HTTP method of the request.
   - **Access-Control-Request-Headers**: Specifies the HTTP headers of the request.
2. **Response Header**
   - **Access-Control-Allow-Origin**: Specifies the origin of the response.
   - **Access-Control-Allow-Methods**: Specifies the HTTP methods of the response.
   - **Access-Control-Allow-Headers**: Specifies the HTTP headers of the response.
   - **Access-Control-Allow-Credentials**: Specifies whether the response should be allowed to be cached.
   - **Access-Control-Max-Age**: Specifies the maximum age of the response.
   - **Access-Control-Expose-Headers**: Specifies the HTTP headers of the response.

Amazon S3 allows you to set CORS to an S3 bucket with static website hosting so different origins can perform HTTP requests from your S3 static website.

The CORS configuration can be either JSON or XML, but currently, the AWS Console only allows JSON configurations.

#### S3 In-Transit Encryption

Data is secure when moving between locations.

This encryption ensures that data remains confidential and cannot be interrupted or viewed by unauthorized parties while in transit.

Data is encrypted on the senders-side and then decrypted on the server-side.

**Encryption Algorithms**
1. **Transport Layer Security (TLS)**
    - An encryption protocol for data integrity between two or more communicating computer applications. TLS 1.2 and TLS 1.3(Best Practice)

2. **Secure Socket Layers (SSL)**
    - An encryption protocol for data integrity between two or more communicating computer applications. SSL 1.0, 2.0, and 3.0 are deprecated.

#### S3 Server-Side Encryption (SSE)

Server-side encryption is always on for all new S3 objects. Server-side encryption only encrypts the contents of an object, and not it's contents.

1. **SSE-S3**
    - Amazon manages all the encryptions.
    - S3 encrypts each object with a unique key.
    - S3 uses envelop encryption.
    - By default, all objects will have SSE-S3 applied.
    - There is no additional charge for using SSE-S3.
    - SSE-S3 uses 256-bit Advanced Encryption Standard (AES-256).
    - Bucket key can be set for SSE-S3 for improved performance.

2. **SSE-KMS**
    - This is when you use a KMS Key managed by AWS.
    - A KMS key managed key is required for SSE-KMS.
    - User chooses the KSM Key to encrypt the S3 object.
    - KMS automatically rotates keys.
    - KMS key policy controls who can decrypt using the key.
    - KMS can help meet regulatory requirements.
    - KMS keys have their own additional costs.
    - AWS KMS keys must be in the same region as the object being encrypted.
    - Uploading with KMS requires kms:GenerateDataKey permissions.
    - Downloading with KMS requires kms:Decrypt permissions.
    - Bucket key can be set for SSE-KMS for improved performance.

3. **SSE-C**
    - User provides their own encryption key that amazon S3 then uses to apply AES-256 encryption on the objects.
    - User needs to provide the encryption key every time they retrieve objects. Then encryption key uploaded to Amazon is deleted after each request.
    - Using SSE-C has no additional cost.
    - Amazon S3 stores a randomly salted hash-based message-auth code (HMAC) of the encryption key to validate future requests.
    - Presigned URLs support SSE-C.
    - With bucket versioning, different object versions can be encrypted with different keys.
    - User manages encryption keys on the client side and any additional safeguards such as key rotations.

4. **DSSE-KMS (Dual-Sided Server-Side Encryption)**
    - This is SSE-KMS with the inclusion of client-side encryption.
    - With DSSE-KMS, daat is encrypted twice.
    - The key used for client-side encryption comes from KMS.
    - There are additional costs for using DSSE and KMS keys.

    **Encryption**
    - Client-side request AWS KMS to generate a data encryption key(DEK) using the CMK.
    - KMS sends two versions of the DEK to the user; a plaintext version and an encrypted version.
    - User uses the plaintext DEK to encrypt their data locally and then discard it from memory.
    - The encrypted version of the DEK is stored alongside the encrypted data in Amazon S3.

    **Decryption**
    - User retrieves the encrypted data and the associated encrypted DEK.
    - User sends the encrypted DEK to AWS KMS, which decrypts the DEK using the corresponding CMK and returns the plaintext DEK.
    - User uses the plaintext DEK to decrypt the data locally and then discard the DEK from memory.

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

### Amazon S3 Select

Amazon S3 Select allows you to use Structured Query Language (SQL) to filter the contents of S3 objects. e.g.

```bash
aws s3api select-object-content \
    --bucket my-bucket \
    --key my-data-file.csv \
    --expression "SELECT * FROM s3object WHERE column_name = 'value'" \
    --expression-type 'SQL' \
    --input-serialization '{"CSV": {}, "CompressionType": "NONE"}' \
    --output-serialization '{"CSV": {}}' "output.csv"
```
It works on objects stored in CSV, JSON, or Apache Parquet format.

It also works with objects that are compressed with GZIP or BZIP2(for CSV and JSON Objects only).

It also works on objects that are server-side encrypted and you can obtain results back in JSON or CSV format.

Amazon S3 Select can be used with the following Storage Classes:
- S3 Standard
- S3 Standard-Infrequent Access
- S3 One Zone-Infrequent Access
- S3 Intelligent-Tiering
- S3 Glacier Instant Retrieval

### S3 Event Notifications

S3 Event Notifications allow you to notify other AWS services about S3 event data. S3 Event Notifications makes application integration very easy for S3.

**Notification Events**

- New Object Created Events
- Object Removal Events
- Restore Object Events
- Reduced Redundancy Storage (RRS) Object lost Events
- Replication Events
- S3 Lifecycles Expiration Events
- S3 Lifecycle Transition Events
- S3 Intelligent-Tiering Automatic Archival Events
- Object Tagging Events
- Object ACL PUT Events

**Possible Notification Destinations**

- Amazon Simple Notification Service (SNS)
- Amazon Simple Queue Service (SQS)
- Amazon Lambda Function
- Amazon EventBridge

Amazon Event Notifications are designed to be delivered at least once. These notications are delivered in seconds but can sometimes take a minute or longer.

### S3 Storage Class Analysis

Storage Class Analysis allows you to analyze storage access patterns of objects within a bucket to recommend objects to move between Standard Storage and Standard IA.

It is a manual process which you can trigger from the S3 Console or using the S3 API as follows:

```bash
aws s3api put-bucket-analytics-configuration\
    --bucket my-bucket --id 1 \
    --analytics-configuration '{"Id": "1", "StorageClassAnalysis": {}}'  
```
S3 Storage Clas Analysis observes the inrequent access patterns of a filtered set of data over a period of time and makes recommendations to move objects between Standard Storage and Standard IA.

You can have multiple analysis filter (up to 1000 filters) per bucket. The results can be exported in CSV format to an S3 bucket.
  - Use data in Amazon QuickSight for data visulization. 

S3 Storage Class Analysis provides storager usage visualization in the Amazon S3 console, that is updated daily.

After a filter is applied, the analysis will be available within 24-48 hours.

Storage Class Analysis will analyze an object for 30 days or longer to gather enough information.

### S3 Storage Lens

Amazon S3 Storage Lens is a storage analysis tool for S3 buckets across your entire AWS organization. S3 Storage Lens provides info on:
- How much storage you have across your AWS organization
- Which are the fastest growing buckets and prefixes
- Identify cost-optimization opportunities
- Implement data protection and access management best practices 
- Improve the performance of application workloads.

S3 Stoarge Lens metrics can be exported as CSV or Parquet format to another S3 bucket. Usage and metrics can also be exported to Amazon CloudWatch.

S3 Storage Lens aggregates metrics and displays the information in the Account Snapshot as an interactive dashboard that is updated daily.

### S3 Static Website Hosting

S3 Static Website Hosting allows you to host and serve a static website from your S3 bucket. S3 website endpoints are **HTTP** endpoints and do not support **HTTPS**. You can use **Amazon CloudFront** to serve a static website over **HTTPS**.

S3 Static Website Hosting can be enabled on a bucket by setting the **WebsiteConfiguration** property on the bucket. It also provides a website endpoint URL as such:

The format of the website endpoint URL varies depending on the region where the bucket is located. It can either have a period, or an hyphen between the region and the word website.

1. `http://bucket-name.s3-website-region.amazonaws.com`
2. `http://bucket-name.s3-website.region.amazonaws.com`

There are two hosting types via the console:
- Host a static website
- Redirect requests to objects

Requester Pays buckets do not allow access through website endpoints because of the bucket configuration.

### Amazon S3 Multipart Upload

Amazon S3 supports multipart upload for objects larger than 100MB. It allows you to upload an object in multiple parts, each part can be uploaded independently and in parallel. Each part can be up to 5GB in size, and you can have up to 10,000 parts per object. The total size of the object can be up to 5TB.

**Multipart Advantages**

- Improved throughput.
- Incase of network failure, you can resume from where the upload stopped.
- Once a multipart has started, parts can be uploaded at any time, there's no expiry for uploading the parts.
- You can upload files while creating a file.

![Multipart-Upload Diagram](./images/s3-multipart-upload.png)

**Multipart Upload Steps**

1. First, initiate the multipart upload, which will return an upload ID.
   ```bash
   aws s3api create-multipart-upload \
       --bucket my-bucket \
       --key 'my-file'
   ```
2. The upload upload each part, by providing the upload ID. Parts can be numbered from 1 to 10000. 
   ```bash
   aws s3api upload-part \
       --bucket my-bucket \
       --key 'my-file' \
       --part-number 1 \
       --body 'part-1' \
       --upload-id "dfRtDYU0WWCCcH43C..."
   ```
   Collect all the Etags for each upload part.

3. Finally, tell S3 that the job is complete. Provide a JSON file with Etags corresponding to each part.

   ```bash
   aws s3api complete-multipart-upload \
       --bucket my-bucket \
       --key 'my-file' \
       --multipart-upload file://parts.json \
       --upload-id 'dfRtDYU0WWCCcH43C...'
   ```
   The JSON file:

   ```JSON
   {"Parts": [
       {"PartNumber": 1, "ETag": "\"etag\""},
       {"PartNumber": 2, "ETag": "\"etag\""},
       {"PartNumber": 3, "ETag": "\"etag\""}
   ]}
   ```

### Amazon S3 Byte Range Fetching

Amazon S3 supports byte range fetching, which allows you to retrieve a specific range of bytes from an S3 object using the Range header during S3 GetObject API requests. This is useful for large objects, as it allows you to retrieve only the data you need.

Example uisng the AWS SDK Python(boto3) Library:

```python
import boto3

s3 = boto3.client('s3')
bucket_name = 'your_bucket_name'
object_key = 'your_object_key'

# Get the first 100 bytes of the object
byte_range = 'bytes=0-99'

response = s3.get_object(
    Bucket='mybucket',
    Key='my-file.txt',
    Range=byte_range
)

# Read the partial content
data = response['Body'].read()
```
Amazon S3 allows for concurrent connections so you can request multiple parts at the same time. 

Fetching smaller ranges of a large object allows your application to improve retry times when request are interrupted.

Typical sizes for byte range requesta are between 8MB and 16MB.

**Multipart Download**

To do a multipart download of a large object, you'll need to store each part and then concat all the parts downloaded in the correct order back into a single file.

**Boto3 Example**:

This example opens multiple S3 connections, holds each part in memory, and the reassembles the parts back into a single file.

```python
import boto3

s3 = boto3.client('s3')
bucket_name = 'your_bucket_name'
object_key = 'your_object_key'

b_range = ['bytes=0-99', 'bytes=100-199', 'bytes=200-299']

# Fetch the parts
parts = []
for byte_range in byte_ranges:
    response = s3.get_object(
        Bucket=bucket_name,
        Key=object_key,
        Range=b_range
    )
    parts.append(response['Body'].read())

# Concatenate all parts
complete_file = b''.join(parts)

# Write the complete file to disk
with open(object_key, 'wb') as f:
    f.write(complete_file)
```
Depending on how large the file is, you might need to write each part to disk if your program does not have enough memory to hold all the parts.

### S3 Interoperability

Interoperability in the context of cloud services is the capability of a cloud service to exchange and utilize information with other cloud services.

Here are some common AWS Services that often dump their data into S3 buckets:
- **Amazon EC2**: Stores snapshots and backups in S3.
- **Amazon RDS**: Backups and exports to S3.
- **AWS CloudTrail**: Stores API call logs in S3.
- **Amazon CloudWatch Logs**: Exports logs/metrics to S3.
- **AWS Lambda**: Outputs data/logs to S3.
- **AWS Glue**: Stores it's ETL results in S3.
- **Amazon Kinesis**: Data streaming to S3 via Firehose.
- **Amazon EMR**: Uses S3 for input/output data storage.
- **Amazon Redshift**: Unloads data to S3.
- **AWS Data Pipeline**: Moves/transforms data to/from S3.
- **Amazon Athena**: Outputs query results to S3.
- **AWS IoT Core**: Stores IoT data in S3.

### AWS Application Programming Interface (API)

**What is an API?**

An API is a software that allows two applications/services to communicate with each other. The most common API type is HTTP/S requests.

AWS API is an HTTP API and you can interact with it by sending HTTP requests using an application interacting with APIs like postman.

Each AWS Service has its own service endpoint which you can send requests to. e.g

```JSON
GET / HTTP/1.1
host: monitoring.us-east-1.amazonaws.com
x-amz-target: GraniteServiceVersion20100801.GetMetricData
x-amz-date: 20260217T135528Z
Authorization: AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20260217/...
Content-Type: application/json
Accept: application/json
Content-Encoding: amz-1.0
Content-Length: 45
Connection: Keep-Alive
```
To authorize, you need to generate a signed request. You make a separatae request using your AWS credentials and get back a token.

You also need to provide an ACTION and accompanying parameters as the payload.

Rarely do users directly send HTTP requests directly to the AWS API since it is a lot of work. It is much easier to interact with the API using Developer tools, i.e AWS SDK, AWS CLI, and AWS Management Console.

![AWS API Interaction](./images/aws-api-interaction.png)

### AWS Command Line Interface (CLI)

**What is a CLI?**

A CLI is a text-based interface that allows you to interact with a computer or software application using text commands. Operating systems implement a CLI in a shell.

**What is a Shell?**

A shell is a program that provides a user interface for accessing the services of an operating system. It is a command-line interface that allows you to interact with the operating system using text commands. e.g

- Bash
- Zsh
- Fish
- PowerShell

**What is a Terminal?**

A termnial is a text-based interface that allows you to interact with a computer or software application using text commands. e.g

- Windows Terminal
- GNOME Terminal
- Konsole
- iTerm2

**What is a console?**

A console is a physical computer to physically input information into a terminal.

The terms **terminal**, **console**, and **shell** are often used to refer to interacting with a shell.

**What is AWS CLI?**

The AWS CLI allows users to programmatically interact with the AWS API using single or multi-line commands in a shell/terminal.

The AWS CLI is a Python executable program and Python is required to be able to install AWS CLI on your Windows, Mac, or Linux/Unix computer.

### AWS Access Keys

AWS Access Keys are used to authenticate and authorize access to AWS services. They consist of an Access Key ID and a Secret Access Key. The Access Key ID is a public identifier, while the Secret Access Key is a private key that is used to sign requests to the AWS API. Access Keys should be treated like passwords and should be stored securely.

An Access Key is commonly referred to as AWS Credentials. A user must be granted access to use Access keys. 

![AWS Access Key Type](./images/aws-access-key-type.png)

- Never share you Access Key with anyone. If you do, you can be held liable for any damages caused by the unauthorized use of your Access Key.
- Never commit your Access Keys to a codebase like GitHub or GitLab.
- You can have two ative Access Keys 
- Access Keys have whatever access the corresponding user has to AWS resources.

![AWS Access Keys](./images/aws-access-key.png)

Access Keys are to be stored in two different ways:

1. **Configuration Files**

    When using configuration files, Access Keys are to be stored in `~/.aws/credentials` and `~/.aws/config` files. e.g

    The `~/.aws/credentials` fie:
    ```ini
    [default]
    aws_access_key_id = AKIAIOSFODNN7EXAMPLE
    aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    [dev]
    aws_access_key_id = AKIAIOSFODNN7EXAMPLE
    aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    ```
    The `~/.aws/config` file contains the default region and output format:

    ```ini
    [default]
    region = us-east-1
    output = json
    ```
    The default will be used when no profile is specified. You can specify a profile using the `--profile` flag. You can store multiple access keys by providing them profile names.

    Both the `~/.aws/credentials` and `~/.aws/config` files can be populated using the `aws configure` command:

    ```bash
    $ aws configure
    AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
    AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    Default region name [None]: us-east-1
    Default output format [None]: json
    ``` 

2. **Environment Variables**

    When using environment variables, Access Keys are to be stored in environment variables. e.g

    ```bash
    export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
    export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    ```
    When using the environment variables method, the AWS CLI and SDKs will automatically use the environment variables to authenticate and authorize access to AWS services.

### API Retries and Exponential BackOff

When interacting with APIs over a network, it is very common for a networking issue to occur for various reasons due to the amount of devices a request has to pass through and point of failures:
- DNS Serversaw
- Switches
- Load Balancers
- Routers
- Firewalls
- etc

To handle these transient failures, APIs implement retry mechanisms with exponential backoff. Exponential backoff is a strategy that increases the delay between retries with each failed attempt. This prevents overwhelming the server with too many requests in a short period of time.

- Try again in 1 seconds
- Try again in 2 seconds
- Try again in 4 seconds
- Try again in 8 seconds
- Try again in 16 seconds
- Try again in 32 seconds

![API Retries and Exponential BackOff](./images/api-retries-and-exponential-backoff.png)

### AWS Security Token Service (STS)

STS is a web service that enables you to request temporary, limited-privilege security credentials for IAM Users or federated users. These temporary credentials consist of an access key ID, a secret access key, and a security token. They are valid for a limited time, typically 15 minutes to 12 hours, and can be used to access AWS services in the same way as long-term access keys. STS is commonly used in conjunction with IAM roles to provide temporary, federated access to AWS resources.

AWS Security Token Service is a global service and all AWS STS requests go to a single enpoint at https://sts.amazonaws.com. 

The following API Actions can be used to obtain STS:
- AssumeRole
- AssumeRoleWithWebIdentity
- AssumeRoleWithSAML
- GetSessionToken
- GetFederationToken
- GetAccessKeyInfo
- GetCallerIdentity
- DecodeAuthorizationMessage

An STS will return:
- Access Key ID
- Secret Access Key
- Session Token
- Expiration Date and Time

**Example STS Request with AWS SDK**

We assume a role via STS and optionally provide a session name:

```python
import boto3

# assume a role and get temporary credentials
sts_client = boto3.client("sts")

response = sts_client.assume_role(
    RoleArn="arn:aws:iam::123456789012:role/MyRole",
    RoleSessionName="MySession"
)

creds = response['credentials']

# load in temporary credentials
s3 = boto3.client('s3',
    aws_access_key_id=creds['AccessKeyId'],
    aws_secret_access_key=creds['SecretAccessKey'],
    aws_session_token=creds['SessionToken']
)
```
This is what is returned by the STS and then loaded into the client:
```json
{
    "Credentials": {
        "AccessKeyId": "AKIAIOSFODNN7EXAMPLE",
        "SecretAccessKey": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
        "SessionToken": "AQoDYXdzEJr...",
        "Expiration": "2026-02-17T15:50:38Z"
    },
    "AssumedRoleUser": {
        "AssumedRoleId": "AROA123456789012:MySession",
        "Arn": "arn:aws:iam::123456789012:assumed-role/MyRole/MySession"
    }
}
```

**Example STS Request with AWS CLI**

We can generate out temporary credentials via STS using the AWS CLI:

```bash
aws sts assume-role \
    --role-arn "arn:aws:iam::123456789012:role/MyRole" \
    --role-session-name "MySession"
```

Output:
```json
{
    "Credentials": {
        "AccessKeyId": "AKIAIOSFODNN7EXAMPLE",
        "SecretAccessKey": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
        "SessionToken": "AQoDYXdzEJr...",
        "Expiration": "2026-02-17T15:50:38Z"
    },
    "AssumedRoleUser": {
        "AssumedRoleId": "AROA123456789012:MySession",
        "Arn": "arn:aws:iam::123456789012:assumed-role/MyRole/MySession"
    }
}
```
Then we can load them into the CLI configurations or the environment variables:

```bash
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_SESSION_TOKEN=AQoDYXdzEJr...
```

### Signing AWS API Requests

When you send API requests to AWS, you sign the request so that AWS can identify who sent them. When you use AWS SDK or AWS CLI, these requests are signed for you automatically.

Signatures do the following:
- Prevent data tampering
- Verify the Identity of the requester

Not all request need to be signed. For example:
- Anonymous requests to S3 buckets 
- Some API operations to STS e.g AssumeRoleWithWebIdentity

AWS has two different protocols for request signing:
- AWS Signature Version 2 (only used in legacy customer's usecases)
- AWS Signature Version 4

**Example Signature in Query Format**

```bash
https://s3.amazonaws.com/example-bucket/test.txt
?X-Amz-Algorithm=AWS4-HMAC-SHA256
&X-Amz-Credential=AKIAIOSFODNN7EXAMPLE%2F20260217%2Fus-east-1%2Fs3%2Faws4_request
&X-Amz-Date=20260217T155038Z
&X-Amz-Expires=300
&X-Amz-SignedHeaders=host
&X-Amz-Signature=<signature-value>
```

### AWS IP Address Ranges

AWS publishes the IP address ranges for all AWS services in JSON format. These ranges are updated regularly, so it is important to use the latest version. The IP address ranges are available in the following endpoint URL: https://ip-ranges.amazonaws.com/ip-ranges.json

Organizations might want these IP ranges for whitelisting purposes in their firewalls or security groups. Since it's a JSON ednpoint the data can be pulled programmatically as follows:

```bash
curl https://ip-ranges.amazonaws.com/ip-ranges.json | jq '.prefixes[] | select(.region == "us-east-1") | select(.service == "CODEBUILD") | .ip_prefix'
```

![AWS IP Address Ranges](./images/aws-ip-address-ranges.png)

### Service Endpoints

An endpoint is the URL of the entry point for an AWS web service. To connect to programmatically to an AWS service, you use an endpoint. For example, the S3 service endpoint in the US East (N. Virginia) Region is https://s3.us-east-1.amazonaws.com. 

Endpoints vary depending on the type of AWS service, but the general fomart is `protocol://service-code.region-code.amazonaws.com`. e.g `https://cloudformation.us-east-1.amazonaws.com`.

Therea are four types of Service endpoints:
1. **Global endpoints**: AWS Services that use the same endpoint. e.g `https://iam.amazonaws.com`, `https://sts.amazonaws.com`, `https://s3.amazonaws.com`
2. **Regional endpoints**: AWS Services that require region specification. e.g `https://cloudformation.us-east-1.amazonaws.com`
3. **Dualstack endpoints**: Allows both IPv4 and IPv6 traffic.
4. **FIPS endpoints**: Endpoints that support FIPS or enterprise use cases.

These types of service endpoints can be combined. e.g Regional+FIPS+Dualstack

An AWS Service may also have multiple different endpoints. For example, S3 has a global endpoint, but it also has regional endpoints. AWS SDK and AWS CLI will automatically pick the default endpoint for the region you are in.

