## Amazon Relational Database Service (RDS)

**Amazon Relational Database Service (Amazon RDS)** is a fully managed web service that simplifies the setup, operation, and scaling of relational databases in the cloud. By
automating administrative tasks like hardware provisioning, database setup, patching, and backups, it allows developers to focus on application development rather than
infrastructure management.

**Features**

- Supports multiple database engines:
  - Aurora PostgreSQL
  - Aurora MySQL
  - Aurora DSQL
  - RDS for PostgreSQL
  - RDS for MySQL
  - RDS for MariaDB
  - RDS for Oracle
  - RDS for Microsoft SQL Server
  - RDS for Db2
- Automatic and manual backups
- High availability and durability with Multi-AZ deployments
- Read replicas for scaling read traffic
- Performance Insights for database performance monitoring
- Customizable DB parameters
- RDS Proxy for a connection pooler
- Various authentication nethods
- Blue/Green Deployments for safe DB updates
- Flexible migration options

![Amazon RDS DB Instances](./images/amazon-rds-db-instances.png)

### RDS Database Engines

1. **MySQL** - The most popular open-source SQL database that was purchased and is now owned by Oracle. It offers replication and partitioning features for scalability and
availabiity.

2. **MariaDB** - A community-driven fork of MySQL, created by the original developers of MySQL after Oracle acquired it. It is designed to be a drop-in replacement for MySQL,
offering better performance and more features.

3. **PostgreSQL** - A powerful, open-source object-relational database system with a strong reputation for reliability, feature robustness, and performance. It supports advanced
data types and functions such as JSON, XML, and key-value pairs for application development, making it a favorite for complex applications.

4. **Oracle** - Oracle Database is a proprietary, commercial relational database management system (RDBMS) developed and marketed by Oracle Corporation. It is one of the most
widely used database management systems in the world, particularly in enterprise environments. Features a complex architecture that supports large-scale databases and
multi-tiered applications.

5. **Microsoft SQL Server** - Microsoft SQL Server is a relational database management system (RDBMS) developed by Microsoft. It is a popular choice for enterprise-level
applications and is known for its scalability, performance, and security features. Integrates seamlessly with other Microsoft products and services, including Azure cloud
services.

6. **IBM Db2** - IBM Db2 is a family of data management products developed by IBM. It is a relational database management system (RDBMS) that supports multiple database engines,
including Db2, Db2 Warehouse, and Db2 on Cloud. Db2 is a popular choice for enterprise-level applications and is known for its scalability, performance, and security features.

7. **Amazon Aurora** - Amazon Aurora is a MySQL and PostgreSQL-compatible relational database that is designed to run on AWS infrastructure. It automatically divides your
database volumes into 10GB segments spread across many disks, enhancing performance and reliability.

### RDS Encryption

- Amazon RDS can encrypt your Amazon RDS DB instances at rest. 
- Data that is encrypted at rest includes the underlying storage for DB instances, its logs, automated backups, read replicas, and snapshots.
- Amazon RDS encrypted DB instances use the industry standard AES-256 encryption algorithm to encrypt your data on the server that hosts your Amazon RDS DB instances.
- Encryption is handled using the AWS Key Management Service(KMS).
- RDS encryption can only be turned on when creating the DB instance, it cannot be turned on later. For already created DB instances, you can take a snapshot and launch new DB instances from the snapshot with encryption turned on.
- Encryption-in-transit is provided by default via the database DNS endpoint.

### RDS Backup

**Amazon RDS** creates and saves automated backups of your DB instance or Multi-AZ DB cluster during the backup window of your DB instance. RDS creates a storage volume snapshot
of your DB instance, backing up the entire DB instance and not just individual databases. RDS saves the automated backups of your DB instance according to the backup retention
period that you specify. If necessary, you can recover your DB instance to any point in time during the backup retention period.

Snapshot and backup functionality supports multi-volume configurations. All backup operations include both the primary volume and any additional storage volumes. Snapshots
capture the entire database storage configuration. Point-in-time recovery (PITR) works across all storage volumes.

The first snapshot of a DB instance contains the data for the full database. Subsequent snapshots of the same database are incremental, which means that only the data that has
changed after your most recent snapshot is saved.

#### Automated Backups

An RDS DB instance must be in the available state for automated backups to occur. Automated backups don't occur while your DB instance is in a state other than available, for
example, storage_full. Automated backups don't occur while a DB snapshot copy is running in the same AWS Region for the same database.

- Choose a retention perod between 0-35 days. 0 days would mean automatic backup is turned off. You can use Point-in-time recovery (PITR) to restore at any 5min interval within your retention period.
- Stores transactional logs throughout the day.
- Automated backups are enabled by default.
- All the backup data is stored inside S3.
- You define your backup window.
- Storage I/O may be suspended during backups.
- Automated backups do not incurr any additional costs.

```sh
aws rds modify-db-instance \
  --db-instance-identifier my-rds-postgres-db \
  --backup-retention-period 7 \
  --preferred-backup-window 03:00-04:00 \
  --apply-immediately
```

#### Manual Backups

- Taken manually by the user.
- The backups persist even if the original RDS instance is deleted.
- RDS DB snapshots can be copied across regions.
- DB snapshots can be shared to other AWS accounts.
- Manual Snapshots can be exported to S3.
- Manual snapshots incurr additional charges.

```sh
aws rds create-db-snapshot \
  --db-snapshot-identifier pre-update-backup \
  --db-instance-identifier my-rds-postgres-db
```

### Restoring Backups

Restoring a backup for automated and manual backups creates a new RDS instance and restores the data to that instance. You provide the name of the DB snapshot to restore from,
and then provide a name for the new DB instance that is created from the restore. You can't restore from a DB snapshot to an existing DB instance; you create a new DB instance
when you restore the snapshot. You can use the restored DB instance as soon as its status is `available`. 

Restoring a manual snapshot via the AWS CLI:

```sh
aws rds restore-db-instance-from-db-snapshot \
  --db-instance-identifier restore-db-instance \
  --db-snapshot-identifier pre-update-backup
```

Restoring a PITR backup via automated backups with the AWS CLI:

```sh
aws rds restore-db-instance-to-point-in-time \
  --source-db-instance-identifier my-rds-postgres-db \
  --target-db-instance-identifier restore-db-instance \
  --restore-time "2026-04-02T12:00:00Z"
```

Restoring DB backups is not a fast process because it involves creating new DB instances, which should be taken into consideration for Recovery Time Objectives(RTOs).

### RDS Subnet Groups

An **Amazon RDS DB subnet group** is a collection of subnets in a Virtual Private Cloud (VPC) that you designate for your DB instances. When you create an RDS instance, you must
associate it with a subnet group, which tells RDS which subnets and IP addresses it can use.

- Each DB Subnet Group should have subnets in at least 2 AZs in a given AWS region.
- RDS will choose a subnet from a subnet group to deploy your RDS instance.
- Subnets in a DB Subnet Group are either private or public.
- For a DB instance to be publicly accessible, all of the subnets in it's DB subnet group must be public.

![RDS Subnet Groups](./images/amazon-rds-subnet-groups.png)

### RDS Multi-AZ Depolyment

You can run your DB instance in several Availability Zones, an option called a Multi-AZ deployment. When you choose this option, Amazon automatically provisions and maintains
one or more secondary standby DB instances in a different AZ. Your primary DB instance is replicated across Availability Zones to each secondary DB instance.

A Multi-AZ deployment provides the following advantages:

- Providing data redundancy and failover support
- Eliminating I/O freezes
- Minimizing latency spikes during system backups
- Serving read traffic on secondary DB instances (Multi-AZ DB clusters deployment only)

#### Multi-AZ Instance Deployment

When the deployment has one standby DB instance, it's called a Multi-AZ DB instance deployment. A Multi-AZ DB instance deployment has one standby DB instance that provides failover support, but doesn't serve read traffic. Multi-AZ Instance deployment is Multi-AZ for Amazon RDS instances. 

![Multi-AZ Instance Deployment](./images/amazon-rds-multi-az-instance-deployment.png)

#### Multi-AZ Cluster Deployment

When the deployment has two standby DB instances, it's called a Multi-AZ DB cluster deployment. A Multi-AZ DB cluster deployment has standby DB instances that provide failover support and can also serve read traffic. Multi-AZ Cluster deployment is Multi-AZ for Amazon Aurora DB clusters. 

![Multi-AZ Cluster Deployment](./images/amazon-rds-multi-az-cluster-deployment.png)

Multi-AZ deployment offer Autoatic Failover protection. In case of a failover, RDS will automatically failover to the secondary DB instance. The failover process can take up to 60 seconds.

You can configure Multi-AZ deployment on already existing RDS instance, using the AWS CLI:

```sh
aws rds modify-db-instance \
  --db-instance-identifier my-rds-postgres-db \
  --multi-az \
  --apply-immediately
```

If not applied immediately, the Multi-AZ will only be provisioned during the next maintenance window. 

### RDS Read Replicas

A **read replica** is a read-only copy of a DB instance. You can reduce the load on your primary DB instance by routing queries from your applications to the read replica. In
this way, you can elastically scale out beyond the capacity constraints of a single DB instance for read-heavy database workloads.

**Read replicas** improve **read contention** which in turn improve database performance and latency. **Read contention** is when multiple processes or instances competing for access to the same index or data block at the same time.

- You must have automated backups enabled, to use Read Replicas
- Asynchronous replication occurs between the primary RDS instance and the replicas.
- You can have up to 5 replicas of a MySQL, MariaDB, and PostgreSQL database. For Aurora, you can have up to 15 replicas. 
- Each Read Replica will have it's own DNS endpoint.
- By deafult, Read Replicas will use the same Storage Type as the source database. The storage type of a Read Replica can be changed independently of the source database.
- You can have Multi-AZ replicas, replicas in other regions, or even replicas of Read Replicas.

![RDS Read Replicas](./images/amazon-rds-multi-az-read-replicas.png)

Replicas can be promoted to their own databases, but this breaks replication, hence no automatic failover support. In the case of a failure, you must manually update URLs to
point to copies.

Creating a Read Replica using the AWS CLI:

```sh
aws rds create-db-instance-read-replica \
  --db-instance-identifier my-rds-postgres-db-replica \
  --source-db-instance-identifier my-rds-postgres-db \
  --allocated-storage 100 \
  --max-allocated-storage 1000 \
  --upgrade-storage-config
```

### Multi-AZ vs Read Replicas

| Multi-AZ Deployments | Read Replicas |
| --- | --- |
| Synchronous replication, highly durable | Asynchrounous replication, highly scalable |
| Only Database engine on primary instance is active | All read replicas are accessible and can be used for read scaling |
| Autonated backups are taken from standy | No backups configured by default |
| Always spans two AZs within a single region | Can be within an AZ, Cross-AZ, or cross-region |
| Database engine version upgrades happen on primary instance | Database engine version upgrade is independent of the source database. |
| Automatic failover to standby when a problem is detected | Can be manually promoted to a standalone database instance |

### DB Instances

A **DB instance** is an isolated database environment running in the cloud. A DB instance can contain multiple user-created databases, and can be accessed using the same client
tools and applications you might use to access a standalone database instance. DB instances are simple to create and modify with the AWS command line tools, Amazon RDS API
operations, or the AWS Management Console.

You can have up to 40 Amazon RDS DB instances, with the following limitations:

- 10 for each SQL Server edition (Enterprise, Standard, Web, and Express) under the "license-included" model
- 10 for Oracle under the "license-included" model
- 40 for Db2 under the "bring-your-own-license" (BYOL) licensing model
- 40 for MySQL, MariaDB, or PostgreSQL
- 40 for Oracle under the "bring-your-own-license" (BYOL) licensing model

Each DB instance has a customer-supplied DB instance identifier, which must be unique for that customer in an AWS Region. The DB instance identifier forms part of the DNS
hostname allocated to your instance by RDS. 

Example: `db1.abcdefghijkl.us-east-1.rds.amazonaws.com`, where `db1` is your instance ID.

### DB Instance Classes

The **DB instance class** determines the computation and memory capacity of an Amazon RDS DB instance. The DB instance class that you need depends on your processing power and
memory requirements. A DB instance class consists of both the DB instance class type and the size.

##### DB Instance Class Types

1. **General Purpose**
   - db.m8g, db.m7i, db.m7g, db.m6g, db.m6i, db.m5, db.m4, db.m3
2. **Memory Optimized**
   - Optimized Z Family(high frequency CPU): db.z1d 
   - Optimized X Family: db.x2g, db.x2i, db.x1
   - Optimized R Family(balanced compute): db.r8g, db.r7g, db.r7i, db.r6g, db.r6i, db.r5b, db.r5d, db.r4, db.r3
3. **Compute Optimized**
   - db.c6gd
4. **Burstable**
   - db.t4g, db.t3, db.t2
5. **Optimized Reads**
   - db.m8gd, db.r8gd, db.r6gd, db.r6id

### DB Instance Storage

DB instances for Amazon RDS for Db2, MariaDB, MySQL, PostgreSQL, Oracle, and Microsoft SQL Server use Amazon Elastic Block Store (Amazon EBS) volumes for database and log
storage.

The following list briefly describes the three storage types:

1. **Provisioned IOPS SSD** – Provisioned IOPS storage is designed to meet the needs of I/O-intensive workloads, particularly database workloads, that require low I/O latency
and consistent I/O throughput. Provisioned IOPS storage is best suited for production environments.

2. **General Purpose SSD** – General Purpose SSD volumes offer cost-effective storage that is ideal for a broad range of workloads running on medium-sized DB instances. General
Purpose storage is best suited for development and testing environments.

3. **Magnetic** – Amazon RDS also supports magnetic storage for backward compatibility. We recommend that you use General Purpose SSD or Provisioned IOPS SSD for any new storage
needs. The maximum amount of storage allowed for DB instances on magnetic storage is 3 TiB. Not recommended.

Maximum storage that most DB instances support is 64 TiB, though it will greatly vary based on engine type, instance type, and size. RDS allows you to increase the storage size
of an EBS volume, but it does not support decreasing the storage size of an EBS volume. To decrease the storage size, you would have to create a new DB instance with less
provisioned storage space.

### RDS Performance Insights

**RDS Performance Insights** enables you to monitor and explore different dimensions of database load based on data captured from a running DB instance. When Performance
Insights is enabled, the Amazon RDS Performance Insights API provides visibility into the performance of your DB instance. Amazon CloudWatch provides the authoritative source
for AWS service-vended monitoring metrics. Performance Insights offers a domain-specific view of DB load.

**Performance Insights** helps to easily identify bottlenecks and performance issues. By default, it is turned on, providing 1 week of performance data. At an additional cost, the retention period can be changed to 2 years.

### RDS Custom

**RDS Custom** automates database administration tasks and operations. RDS Custom makes it possible for you as a database administrator to access and customize your database
environment and operating system. With RDS Custom, you can customize to meet the requirements of legacy, custom, and packaged applications.

With Custom RDS, you can:

- Install third-party applications.
- Install custom database and OS patches and packages.
- Configure specific database settings.
- Configure file systems to share files directly with their applications.

RDS Custom works with:

- Microsoft SQL Server
- Oracle Database

![RDS Custom](./images/amazon-rds-custom-architecture.png)

How it works:

- You create RDS Custom DB instances
- You connect an RDS Custom DB instance endpoint
- Directly access the host to make changes

![RDS Custom](./images/amazon-rds-custom-architecture-1.png)

### RDS Proxy

**Amazon RDS Proxy** is a fully managed, highly available database proxy for Amazon RDS that makes applications more scalable, resilient, and secure. It acts as an intermediary
between your application and your database to handle connection pooling and failover.

### RDS Proxy Benefits

1. **Improved Application Performance**: RDS Proxy maintains a pool of established connections to your RDS database instances, reducing the stress on database compute and memory
resources that typically occurs when new connections are established.
2. **Increased Application Availability**: RDS Proxy minimizes application disruption from outages affecting the availability of your database by automatically connecting to a
new database instance while preserving application connections. 
3. **Enhanced Application Security**: RDS Proxy gives you additional control over data security by giving you the choice to enforce IAM authentication for database access and
avoid hard coding database credentials into application code.
4. **Reduced Operational Burden**: RDS Proxy is fully serverless and a fully managed database proxy so it automatically scales to accommodate your workload while removing the
burden of patching and managing your own proxy server.

![RDS Proxy](./images/amazon-rds-proxy-architecture.png)

### RDS Optimized Reads and Writes

**RDS Optimized Reads and Writes** are performance-enhancing features designed to accelerate database workloads at no additional cost by leveraging specialized hardware and
optimized I/O paths. Writes 0.5X faster and Reads 2X faster.

RDS Optimized Reads and Writes utilizes NVMe-based SSD block storage instead of AWS EBS for temporary tables for greater performance. 

Queries that use temporary tables; sort, hash aggregations, high-load joins, and Common Table Expressions (CTEs).

RDS Optimized Reads and Writes are available for specific combination of Instance Classes and Engine Versions. eg.

- db.r5b + MySQL 8.0
- Some DB Engines only allow for optimized reads.
- Reads and writes have different requirements.
- Additional database configurations may be required to take advantage of optimized reads and writes.

### RDS IAM Authentication

**RDS IAM database authentication** allows you to connect to your DB instance or cluster using AWS Identity and Access Management (IAM) credentials instead of a traditional
password. This method uses short-lived authentication tokens generated by Amazon RDS upon request.

IAM database authentication works with MariaDB, MySQL, and PostgreSQL. With this authentication method, you don't need to use a password when you connect to a DB instance.
Instead, you use an authentication token.

An **authentication token** is a unique string of characters that Amazon RDS generates on request. Authentication tokens are generated using AWS Signature Version 4. 

- Each token has a lifetime of 15 minutes. You don't need to store user credentials in the database, because authentication is managed externally using IAM.
- You can also still use standard database authentication, alongside IAM authentication.
- Users can use IAM Authentication instead of having to use a password.
- EC2 instances can use IAM Authentication instead of having to use a password.

1. Enable IAM Authentication on an RDS instance:

   ```sh
   aws rds modify-db-instance \
     --db-instance-identifier my-db-instance \
     --enable-iam-database-authentication \
     --apply-immediately
   ```
2. Create a policy and attach to user or role to allow ability to authenticate as specific users:
   
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "rds-db:connect"
         ],
         "Resource": [
           "arn:aws:rds-db:us-east-1:123456789012:dbuser:my-hello/db-user-1",
           "arn:aws:rds-db:us-east-1:123456789012:dbuser:db-hello/db-user-2"
         ]
       }
     ]
   }
   ```
3. Create DB users and grant database access(Postgres):
   
   ```sql
   CREATE USER db-user-1;
   CREATE USER db-user-1;
   GRANT db-hello To db-user-1;
   GRANT db-hello To db-user-2;
   ```
4. Generate Authentication token to be used in place of password when authenticating:

   ```sh
   export RDSHOST = "db-hello.123456789012.us-east-1.rds.amazonaws.com"
   export PGPASSWORD = "$(aws rds generate-db-auth-token \
     --hostname $RDSHOST \
     --port 5432 \
     --username db-user-1 \
     --region us-east-1)"
   ```
### RDS Kerberos Authentication

**Amazon RDS Kerberos authentication** provides a centralized, secure way to manage database user identities by integrating with Microsoft Active Directory (AD). It enables
features like Single Sign-On (SSO), allowing users to authenticate to database instances using their existing AD credentials without sending passwords over the network.

RDS support for Kerberos and Active Directory provides the benefits of single sign-on and centralized authentication of database users. It works with:

- AWS Directory Service for Microsoft Active Directory
- On-premises Active Directory

It can be used with:

- Microsoft SQL Server
- PostgreSQL
- MySQL
- Oracle

Microsoft SQL Server and PostgreSQL DB instances support one and two-way forest trust relationships, while Oracle DB instances support one-way and two-way external and forest
relationships.

### RDS Secrets Manager Integration

Amazon RDS supports integration with **AWS Secrets Manager** to streamline how you manage your master user password for your RDS database instances. With this feature, RDS fully
manages the master user password and stores it in AWS Secrets Manager whenever your RDS database instances are created, modified, or restored. 

The feature supports the entire lifecycle maintenance for your RDS master user password including regular and automatic password rotations; removing the need for you to manage
rotations using custom Lambda functions.

RDS integration with AWS Secrets Manager improves your database security by ensuring your RDS master user password is not visible in plaintext to administrators or engineers
during your database creation workflow. Furthermore, you have flexibility in encrypting the secrets using your own managed key or by using a KMS key provided by AWS Secrets 
Manager.

- By default, the secret will be rotated every 7 days.
- Web applications will have to be configured to access the password programmatically from AWS Secrets Manager.
- The secret is deleted when the RDS instance is deleted.

Secrets Manager Integration does not work with:

- Microsoft SQL Server
- Amazon RDS Blue/Green deployments
- Amazon RDS Custom
- Oracle Data Guard Switchover
- RDS for Oracle with CDB

Let Secrets Manager manage master user passwords for RDS:

```sh
aws rds modify-db-instance \
  --db-instance-identifier my-db-instance \
  --db-instance-class  db.m5.large \
  --manage-master-user-password \
  --apply-immediately
```

RDS generates the master user password and manages it throughout it's lifecycle in Secrets Manager. 

### RDS Master User Account

**Master User Account** in RDS is the initial database account that's created when you provision a new DB instance. It is not a superuser (like root or sysdba) but has 
high-level permissions for most tasks, with security, auditing, and backups handled by RDS.

This account is granted full administrative privileges on the database: i.e

- Creating tables
- Creating schemas
- Performing SQL operations

It's not recommended to use the Master User Account for daily use. Instead, it's recommended to create a user with the least amount of privileges required for the task at hand. 

The Master User Account username and password is set at the time of creating the DB instance:

```sh
aws rds create-db-instance \
  --db-instance-identifier my-db-instance \
  --engine mysql \
  --engine-version 8.0.35 \
  --db-instance-class  db.m5.large \
  --allocated-storage 20 \
  --master-username  my-master-user \
  --master-user-password  my-master-password
```

The username will be visible in the AWS Management Console.

The Master Account user password can be reset as follows:

```sh
aws rds modify-db-instance \
  --db-instance-identifier my-db-instance \
  --master-user-password  my-new-password \
  --apply-immediately
```

The password format and restrictions vary depending on the database engine but the general rules also apply, such as a minimum of 8 characters.

### RDS Database Activity Streams

**Amazon RDS Database Activity Streams (DAS)** provides a near real-time stream of all audit events from your database, allowing you to monitor and audit database activity for security and compliance.

Database Activity Streams can be enabled via the AWS CLI:

```sh
aws rds start-activity-stream \
  --mode async \
  --kms-key-id my-kms-key-id \
  --resource-arn my-db-instance-arn \
  --engine-native-audit-fields-include \
  --apply-immediately 
```

- Amazon RDS pushes activities to an Amazon Kinesis Data Stream in near real-time
- A Kinesis Stream is created automatically. Active Streams feature in Amazon RDS is free, but Kinesis is not.
- From Kinesis, you can monitor the activity stream, or other services and applications can consume the activity stream for further analysis.

### RDS Parameter Groups

**Amazon RDS parameter groups** act as a configuration engine for your database, allowing you to manage engine settings (like memory allocation, connection limits, and logging) 
for one or more DB instances. Parameter groups let you change database parameters to specify how you want your instance(s) to be configured.

This can be done using the AWS CLI as follows:

```sh
aws rds modify-db-parameter-group \
  --db-parameter-group-name my-db-parameter-group \
  --parameters "ParameterName=my-parameter,ParameterValue=my-value,ApplyMethod=immediate" \
  --apply-immediately
```

Each database engine has its own set of parameters that can be modified. For example, Postgres has the following:

- `work_mem`: Memory for  sort operations; increase for complex queries
- `shared_buffers`: Memory for shared buffers; typically 25-40% of system memory
- `maintenance_work_mem`: Memory for maintenance operations; increase for faster vacuuming/indexing
- `effective_cache_size`: Helps query planner with estimating available memory for caching
- `checkpoint_completion_target`: Spreads checkpoint writes over time; closer to 1.0 for even spread
- `wal_buffers`: Memory for write-ahead log (WAL) buffers; increase to batch writes and reduce I/O

### RDS Public Accessibility

In Amazon RDS, Public Accessibility determines whether a database instance is assigned a public IP address and is reachable from outside its Virtual Private Cloud (VPC) via the internet.

Passing the Public Access(sible) option changes if the DNS endpoint will resolve to the private IP address from traffic outside of the VPC.

```sh
aws rds create-db-instance \
  --db-instance-identifier my-db-instance \
  --db-instance-class  db.m5.large \
  --engine mysql \
  --engine-version 8.0.35 \
  --allocated-storage 20 \
  --master-username  adminuser \
  --master-user-password  mysecuremasterpassword \
  --publicly-accessible \
  --backup-retention 7 
```

Public access does not override Security Group rules, so you must still configure Security Groups to allow traffic from the internet to your DB instance ports. 

Public Access feature is useful when you are confident with password authentication and security groups, and you want the convinience of connecting to your RDS instance without 
having to use an intermediate way for accessing the instances database.

### Establishing Public Connections

There are a few options for connecting to a Public RDS endpoint:

1. Use a Database Management / DB IDE tool to establish a connection to the RDS instance. eg. TablePlus, Dbeaver, DataGrip, Navicat.
2. Use AWS CloudShell and use a database client or database driver via code to establish a connection.
3. Use a database client via your local terminal. eg. psql, mysql, mariadb
4. Programmatically connect with a database driver from your preferred programming language. eg. JDBC, ODBC, Python DB-API, etc.

![Public RDS Instance](images/amazon-public-rds-instance.png)

#### Connection url string

A connection url string is a single string containing all the parameters to connect to a database. It's a convenient way to quickly configure a connection for database drivers and database command line clients. The connection string may vary between database drivers and database command line tools.

- **MySQL Format**: `mysql://[hostname]:[port]/[databaseName]?[propertise]`
- **MariaDB Format**: `mariadb://[hostname]:[port]/[databaseName]?[propertise]`
- **Postgres Format**: `postgresql://[username]:[password]@[hostname]:[port]/[databaseName]?[propertise]`
- **Oracle Format**: `oracle:thin:@[hostname]:[port]:[SID]` or `jdbc:oracle:thin:@//[hostname]:[port]/[serviceName]`  
- **SQL Server Format**: `sqlserver://[hostname]:[port]/;databaseName=[databaseName];user=[user];password=[password]`

Default Ports for DB engines:

- MySQL: 3306
- MariaDB: 3306
- PostgreSQL: 5432
- Oracle: 1521
- SQL Server: 1433
- Aurora MySQL: 3306
- Aurora PostgreSQL: 5432

Example of using a string to connect via the PSQL command line tool:

```sh
psql postgresql://gidii:testing123@my-postgres-db.123456789012.us-east-1.rds.amazonaws.com:5432/mydatabase
```

### Establishing Private Connections

![Private RDS Instance](./images/amazon-rds-establishing-private-connections.png)

Connection options:

- Luanch a CLoud9 server(in a public subnet) in the same VPC.
- Connect through a bastion or jumpbox and tunnel through the box.
- Launch an EC2 instance and connect via SSH or Session Manager to establish a connection.
- Use AWS Client VPN to connect local machine to VPC and establish a connection to the VPC.
- For On-Premise networks, use AWS Direct Connect to establish a connection to the VPC.
- AWS CloudShell cannot be used to establish a connection to a private RDS instance because it is not in the same VPC.

### RDS Security Groups

**Amazon RDS security groups** act as a virtual firewall for your database, controlling which network traffic is allowed to reach or leave your DB instance.

Amazon RDS security groups enable you to manage network access to your Amazon RDS instances. With security groups, you specify sets of IP addresses using CIDR notation, and only 
network traffic originating from these addresses is recognized by your Amazon RDS instance.

Although they function in a similar way, Amazon RDS security groups are different from Amazon EC2 security groups. It is possible to add an EC2 security group to your RDS 
security group. Any EC2 instances that are members of the EC2 security group are then able to access the RDS instances that are members of the RDS security group.

![RDS Security Group](./images/amazon-rds-security-groups.png)

### RDS Blue/Green Deployments

**Amazon RDS Blue/Green Deployments** provide a fully managed staging environment that allows you to test database changes—such as engine upgrades, schema modifications, or 
parameter updates—against a mirror of your production data before promoting them to the live environment.

A blue/green deployment creates a staging environment that copies the production environment. The blue environment is the current production environment, and the green 
environment is the staging environment and stays in sync with the current production environment.

You can make changes to the RDS DB instances in the green environment without affecting production workloads. For example, you can upgrade the major or minor DB engine version 
upgrade the underlying file system configuration, or change database parameters in the staging environment.

You can thoroughly test changes in the green environment. When ready, you can switch over the environments to transition the green environment to be the new production 
environment. The switchover typically takes under a minute with no data loss and no need for application changes.

Because the green environment is a copy of the topology of the production environment, the green environment includes the features used by the DB instance. These features 
include the read replicas, the storage configuration, DB snapshots, automated backups, Performance Insights, and Enhanced Monitoring. If the blue DB instance is a Multi-AZ DB 
instance deployment, then the green DB instance is also a Multi-AZ DB instance deployment.

Currently, blue/green deployments are supported only for RDS for MariaDB, RDS for MySQL, and RDS for PostgreSQL. Under certain conditions, RDS for PostgreSQL uses logical 
replication instead of physical replication to keep the green environment in sync with the blue environment.

Creating a Blue/Green deployment for RDS via the AWS CLI:

```sh
aws rds create-blue-green-deployment \
  --blue-green-deployment-name my-blue-green-deployment \
  --source arn:aws:rds:us-east-1:123456789012:db:my-db-instance \
  --target-engine-version 15.4 \
  --target-db-parameter-group-name my-db-parameter-group \
  --target-db-instance-class db.m5.8xlarge \
  --upgrade-target-storage-config 
```

### RDS Extended Support

**Amazon RDS Extended Support** allows you to continue running a database on a major engine version past the RDS end of standard support date for an additional cost. 

You can only enroll a database in RDS Extended Support by enabling RDS Extended Support when you first create or restore a DB instance. You can't update your RDS Extended 
Support enrollment status on existing DB instances unless you are restoring them.

If you enabled RDS Extended Support during the creation or restoration of a DB instance, then after the RDS end of standard support date, Amazon RDS will automatically enroll 
the DB instance in RDS Extended Support. Automatic enrollment into RDS Extended Support doesn't change the database engine and doesn't impact the uptime or performance of your 
DB instance.

RDS Extended Support provides the following updates and technical support:

- Security updates for critical and high CVEs for your DB instance or DB cluster, including the database engine
- Bug fixes and patches for critical issues
- The ability to open support cases and receive troubleshooting help within the standard Amazon RDS service level agreement

This paid offering gives you more time to upgrade to a supported major engine version. 

RDS Extended Support is available for up to 3 years past the RDS end of standard support date for a major engine version. After this time, if you haven't upgraded your major 
engine version to a supported version, then Amazon RDS will automatically upgrade your major engine version.

## Amazon Aurora

**Amazon Aurora** is a fully managed, high-performance relational database engine compatible with MySQL and PostgreSQL, offering up to 5x the throughput of standard MySQL and 3x of PostgreSQL. Designed for cloud-native applications, it provides high availability, auto-scaling storage up to 128TB, and enterprise-grade security.

Aurora includes a high-performance storage subsystem. Its MySQL- and PostgreSQL-compatible database engines are customized to take advantage of that fast distributed storage. 
The underlying storage grows automatically as needed. An Aurora cluster volume can grow to a maximum size of 128 tebibytes (TiB). Aurora also automates and standardizes database 
clustering and replication, which are typically among the most challenging aspects of database configuration and administration.

### Scaling

#### Durability and Fault Tolerance

- Aurora backups and Failover are handled autmatically.
- Snapshots of data can be shared with other AWS accounts.
- Storage is self-healing; the data blocks and disks are continuously scanned for errors and repaired automatically.

#### Availability

- Aurora deploys in a minmum of three AZs, each containing 2 copies of your data at all times.
- That means that there are 6 copies of your data in total.
- You can lose up to 2 copies of your data without affecting write availability.
- You can lose up to 3 copies of your data without affecting read availability.

#### Storage

- A cluster starts with 10GB of storage, and scales in 10GB increments up to 64TB or 128TB depending on the DB engine version.
- Storage automatically scales with the data in your cluster volume.
- Compute resources can scale up to 32 vCPUs and 244GB memory.

#### Security

- TLS/SSL certificates can be applied to encrypt security connections so that termination occurs at the database.
- Data is encrypted at rest and cannot be turned off. Can use KMS to manage keys.

### Aurora Provisioned

**Amazon Aurora Provisioned** is a database configuration where you manually choose and manage the specific compute instance types for your database cluster. Unlike 
the **Aurora Serverless** version that autoscales, the provisioned model requires you to select instance sizes (e.g., db.r6g.large) based on your expected workload. **Aurora 
Provisioned** is the default compute configuration for Amazon Aurora. 

Aurora DB cluster contains a primary DB instance that performs reads and writes, and optionally, up to 15 Aurora Replicas(read DB instances). To create an Aurora DB provisioned 
cluster via the AWS CLI:

```sh
aws rds create-db-cluster \
  --db-cluster-identifier my-aurora-cluster \
  --engine aurora-mariadb \
  --engine-version 11.4.0 \
  --master-username admin \
  --master-user-password [PASSWORD] \
  --backup-retention-period 7 \
  --preferred-backup-window 03:00-04:00 \
  --preferred-maintenance-window Sun:23:00-Mon:01:00
```

The primary DB instance will not be created for you by default. You will need to create your DB instances separately after creating your cluster. 

### Aurora Reader and Writer Instances

Amazon Aurora has two types of instances within a cluster: 

- Reader Instances
- Writer Instances

| | Writer Instance | Reader Instance |
| --- | --- | --- |
| Role | Handles writes; can also read | Handles reads |
| Quantity | One Per cluster | 15 per cluster for scalability |
| Scalabiltiy | Vertical only(upgrade instance) | Horizontal(add more instances) |
| Availability | Critical; failure triggers failover | Distributes reads; can be failover target |
| Use Cases | Transactional charges | Read-heavy workloads, analytics |
| Failver Capability | Automatic promotion of a reader incase of failure | Can be promoted to writer |
| Cost | Based on instance size and IOPS | Increases with each instance added |

The first DB instance created in your cluster will be the writer instance:

```sh
aws rds create-db-instance \
  --db-instance-identifier my-writer-instance \
  --db-instance-class db.r4.large \
  --engine aurora-mariadb \
  --engine-version 11.4.0 \
  --db-cluster-identifier my-aurora-cluster
```

All other instances created afterwards will be reader instances(Aurora replicas):

```sh
aws rds create-db-instance \
  --db-instance-identifier my-reader-instance \
  --db-instance-class db.r4.large \
  --engine aurora-mariadb \
  --engine-version 11.4.0 \
  --db-cluster-identifier my-aurora-cluster
```

### Aurora Serverless v2

**Amazon Aurora Serverless v2** is an on-demand, autoscaling configuration for Amazon Aurora that automatically adjusts database capacity based on application demand. It is 
designed to handle everything from small, infrequent workloads to large, business-critical applications requiring high availability.

- Capacity is adjusted automatically based on application demand.
- You are charged only for the resourcs that your database cluster consumes.
- Suitable for the most demanding, highly variable workloads.
- Aurora "Serverless" v2 does not scale to zero and must maintain at least 0.5 ACUs.
- Only certain Aurora Instance classes are available to use with Aurora Serverless v2.

#### Aurora Capacity Unit (ACU)

ACU is the unit of measurement for Aurora Serverless v2 capacity. It is equivalent to 2 GiB of memory and 1 vCPU. The capacity ranges between 0.5 ACUs - 128 ACUs.

When you configure your Aurora cluster for Serverless v2, you set the Minimum and Maximum ACU capacity:

```sh
aws rds create-db-cluster \
  --db-cluster-identifier my-aurora-cluster \
  --region us-east-1 \
  --engine aurora-mariadb \
  --engine-version 11.4.0 \
  --master-username admin \
  --master-user-password [PASSWORD] \
  --serverless-v2-scaling-configuration MinCapacity=1,MaxCapacity=10
```

When creating a Writer instances for your serverless cluster, you need to specify the db class as being `db.serverless`:

```sh
aws rds create-db-instance \
  --db-cluster-identifier my-serverless-v2-cluster \
  --db-instance-identifier my-serverless-v2-writer \
  --db-instance-class db.serverless \
  --engine aurora-mariadb 
```

### Aurora Serverless V2 vs Aurora Provisioned

| | Aurora Serverless V2 | Aurora Provisioned |
| --- | --- | --- |
| Scaling | Fine-grained, almost instant scaling | Manual scaling, requires planning and downtime |
| Capacity Range | 0.5-128 ACUs, more flexible | Fixed, based on instance chosen. |
| Scaling speed | Seconds | N/A (manual intervention required) | 
| Read/Arite scaling | Independently | Depends on instance type and read repica configuration |
| Compatibility | Broader version support | Wide version suppor, depdending on the instance type. |
| Use cases | Highly variabel workkloads requiring immediate scaling | Stable workloads with predictable performance needs |
| Billing | ACUs per second, more granular, + storage. | Instance hours + storage. |
| Start/Stop | Responsive start/stop, cost-saving for intermittent loads. | Manual start/stop. | 
| Maintenance | Minimal downtime, seamless. | Scheduled maintenance windows. | 

### Aurora Global Database

**Amazon Aurora Global Database** is a feature designed for globally distributed applications, allowing a single Aurora database to span multiple AWS Regions. It provides 
low-latency local reads and robust cross-Region disaster recovery with minimal impact on performance.

- Has a primary cluster in 1 region
- Has up to 5 secondary DB clusters in different regions
- Write operations occur on the primary cluster
- Data is replicated to secondary clusters using dedicated infrastructure
- Global Database is only available in specific regions and specific database versions

![Aurora Global Database](./images/amazon-aurora-global-database.png)

To create an Aurora global database and its associated resources by using the AWS CLI, use the following steps:

1. Create an Aurora global database cluster, giving it a name and specifying the Aurora database engine type that you plan to use.

   ```sh
   aws rds create-global-cluster \
     --region primary_region \
     --global-cluster-identifier global_database_id \
     --engine aurora-mysql \
     --engine-version version # optional
   ```
2. Create an Aurora DB primary cluster for the Aurora global database.
   
   ```sh
   aws rds create-db-cluster \
     --region primary_region \
     --db-cluster-identifier primary_db_cluster_id \
     --master-username userid \
     --master-user-password password \
     --engine aurora-mysql \
     --engine-version version \
     --global-cluster-identifier global_database_id
   ```
3. Create the Aurora DB instance for the cluster. This is the primary Aurora DB cluster for the global database.

   ```sh
   aws rds create-db-instance \
     --db-cluster-identifier primary_db_cluster_id \
     --db-instance-class instance_class \
     --db-instance-identifier db_instance_id \
     --engine aurora-mysql \
     --engine-version version \
     --region primary_region
   ```
4. Create a secondary Aurora DB cluster in a different region.
   
   ```sh
   aws rds create-db-cluster \
     --region secondary_region \
     --db-cluster-identifier secondary_db_cluster_id \
     --engine aurora-mysql \
     --engine-version version \
     --global-cluster-identifier global_database_id
   ```
5. Create an Aurora DB instance for the secondary cluster. This is a reader to complete the Aurora DB cluster.
   
   ```sh
   aws rds create-db-instance \
     --db-cluster-identifier secondary_db_cluster_id \
     --db-instance-class instance_class \
     --db-instance-identifier replica_db_instance_id \
     --engine aurora-mysql \
     --region secondary_region
   ```

When the DB instance is available, replication begins from the writer node to the replica.

### Aurora RDS Data API

**Amazon RDS Data API** is a secure HTTPS endpoint that allows you to run SQL statements against Amazon Aurora databases without the need for persistent database connections or 
specialized drivers. It is particularly designed for modern, cloud-native applications such as those using AWS Lambda.

- It provides a secure HTTP endpoint and integration with AWS SDKs. 
- You can use the endpoint to run SQL statements without managing connections.
- Unlimited max request per second.
- Must be enabled on the DB cluster to use.
- By default, Data API calls are excluded by CloudTrail since they are data events.
- Multi-statements are not supported.
- Cannot reterive multi-dimensional arrays for a column.
- Supports specific data types.
- Supports execution and transaction statements.

To enable Data API on your Aurora DB cluster:

```sh
aws rds enable-http-endpoint \
  --resource-arn cluster-arn
```

To execute an SQL statement using the RDS Data API:

```sh
aws rds-data execute-statement \
  --resource-arn "arn:aws:rds:us-east-1:123456789012:cluster:my-aurora-cluster" \
  --secret-arn "arn:aws:secretsmanager:us-east-1:123456789012:secret:my-aurora-cluster-secret" \
  --sql "SELECT * FROM users" \
  --database "mydb" \
  --region us-east-1
```

Aurora in the AWS Management Console has a Query Editor, which is just an interface to connect and use the RDS Data API.

### Babelfish for Aurora 

**Babelfish** for PostgreSQL is an open-source library with the compatibility for PostgreSQL to understand queries for applications written for SQL Server.

**Babelfish for Aurora PostgreSQL** extends your Aurora PostgreSQL DB cluster with the ability to accept database connection requests form Microsoft SQL.

With **Babelfish**, apps originally built for Microsoft SQL Server can work directly with Aurora PostgreSQL with few code changes compared to a traditional migration and without changing database drivers.

- Both SQL dialects supported by Babelfish are available through their native write protocols at the following ports:
  - SQL Server dialetc (T-SQL), port 1433.
  - PostgreSQL dialect (PL/pqSQL), port 5432.
- Babelfish runs the Transact-SQL (T-SQL)
- Babelfish currently does not support:
  - RDS Blue/Green deployments
  - AWS IAM
  - Database Activity Streams (DAS)
  - PostgreSQL Logical replication
  - RDS Data API with Aurora Serverless v2 and Provisioned
  - RDS Proxy with RDS for SQL Server
  - Salted Challenge Response Authentication Mechanism (SCRAM)
  - Query Editor
  - Kerberos Authentication via Active Directory
  
## MongoDB

**MongoDB** in an open-source document database which stores JSON-like documents. It's primary data structure is BSON (Binary JSON).

**Binary JSON(BSON)**

- BSON is a binary representation of JSON-like documents.
- BSON is designed to be more efficient both in terms of storage space and scan speed compared to JSON.
- BSON has more data types than JSON eg.
  - Datetime, byte arrays, regular expressions, MD5 binary data, javascript code.

Example BSON file:

```bson
BSON:
  \x16\x00\x00\x00
  \x02
  hello\x00
  \x06\x00\x00\x00world\x00
  \x00
```
Query Operation on a MongoDB databse:

```sh
db.collection.insertMany([
  {
    name: "John Doe",
    age: 30,
    email: "[EMAIL_ADDRESS]"
  },
  {
    name: "Jane Doe",
    age: 25,
    email: "[EMAIL_ADDRESS]"
  }
]);
```

- MongoDB is used with an interactive shell (mongosh) or a MongoDB driver in a programming language.
  - Traditionally, MongoDB does not use an SQL language, but there is MQL and Atlas SQL to query MongoDB.
- The default port for MongoDB is 27017.
- MongoDB supports searches against fields, range queries, and regular expressions.
- MongoDB supports primary and seconday indexes.
- High availability can be obtained via replica sets (replica sets to offload reads and provide failover).
- MongoDB scales horizontally via sharding (sharding to distribute data across multiple shards).
- MongoDB can be used as a file system (GridFS), with load balancing and data replication features over multiple machines for storing files.
- MongoDB provides three ways to perform aggregation(grouping data during a query):
  - Aggregation pipeline
  - Map-reduce operations
  - Single-purpose aggregation operators
- MongoDB supports fixed-size collections called capped collections.
- MongoDB claims to support multi-document ACID transactions.

## Amazon DocumentDB

**Document Store**

A **document** store is a NOSQL database that stores documents as it's primary data structure. A document could be an XML but more commonly is JSON or JSON-like. Document 
Stores are a sub-class of Key/Value stores.

The components of a Document store compared to a real SQL database:

![Document Store vs SQL Database](./images/document-store-vs-sql-database.png)

**Amazon DocumentDB** is a fully managed, scalable, and highly available NoSQL document database service designed to store, query, and index JSON 
data at scale. It allows developers to use the same MongoDB application code, drivers, and tools they already use, while providing the performance and reliability of a managed 
AWS service.

MongoDB is a very popular NOSQL database among developers , but there were open-source licensing issues around using open-source MongoDB, so AWS got around it by building their 
own NOSQL database, famously known as **Amazon DocumentDB**.

Cluster types:

1. Instance based cluster: Manage your instances, directly choosing instance type.
2. Elastic Cluster: Cluster automatically scale, you choose vCPU and number of instances per shard.

DocumentDB is compatible with MongoDB 4.0, and 5.0

DocumentDB does not support all functionalities of MongoDb eg. Writeable retries

DocumentDB storage volumes grow in increments of 10GB, up to a maximum of 128TiB.

Create upto 15 replicas.

Amazon DocumentDB continously monitors the health of the cluster and automatically restarts failed instances.

Failover will automatically occur to up to 15 replicas in other AZs.

Backup is turned on by default(cannot be turned off), with a retention period of between 1-35 days, supports point-in-time recovery.

Clusters are deployed into a customer's VPC
- Offers a performance insights feature to determine bottlenecks for reads and writes.
- Data is encrypted in-transit and at rest.
- Connection must be via TLS.

## Amazon DynamoDB

**Amazon DynamoDB** is a fully managed, serverless, NoSQL database service providing consistent, single-digit millisecond performance at any scale. It supports key-value and 
document data models, making it ideal for high-traffic applications like gaming, e-commerce, and mobile backends. Key features include automatic scaling, built-in security, and 
ACID transactions.

### Features

1. **Performance and scalability**
   - With DynamoDB, there are no servers to provision, patch, or manage, and no software to install, maintain, or operate.
   - DynamoDB offers warm throughput which means all resources are instantaneously available.
   - Secondary indexes enhance DynamoDB's performance primarily by enabling efficient querying of data using attributes other than the table's primary key. 
2. **Security**
   - DynamoDB encrypts all customer data in transit and at rest by default.
   - DynamoDB uses AWS Identity and Access Management (IAM) to authenticate and authorize access to resources.
   - DynamoDB supports gateway virtual private cloud (VPC) endpoints and interface VPC endpoints for connections within a VPC or from on-premises data centers.
3. **Resilience**
   - Point-in-time recovery (PITR) helps protect your DynamoDB tables from accidental write or delete operations.
   - On-demand backup and restore allows you to create full backups of your DynamoDB tables’ data for data archiving, helping you meet your corporate and governmental 
   regulatory requirements.
   - DynamoDB global tables provides active-active replication of your data across your choice of AWS Regions with 99.999% availability.
   - DynamoDB is built for mission-critical workloads, including support for atomicity, consistency, isolation, and durability (ACID) transactions for applications that requir 
   complex business logic.
4. **Cost-effectiveness**
   - You only pay for the reads and writes made by your application.
   - For data that is infrequently accessed, DynamoDB Standard-IA table class reduces storage costs by 60% compared to existing Standard tables while delivering the same 
   performance, durability, and scaling capabilities.
   - DynamoDB provides capacity modes for each table: on demand and provisioned.
   - For tables using provisioned capacity, DynamoDB provides auto scaling of throughput and storage based on your previously set capacity by monitoring the performance usage 
   of your application.
5. **Integrations with AWS services**
   - Amazon DynamoDB bulk import and export capabilities provide a simple and efficient way to move data between Amazon S3 and DynamoDB tables without writing any code.
   - DynamoDB Streams is a change data–capture capability. Whenever an application creates, updates, or deletes items in a table, DynamoDB Streams record a time-ordered 
   sequence of every item-level change in near real time, making it ideal for event-driven architecture applications to consume and action the changes.
   - Amazon Kinesis Data Streams for DynamoDB captures item-level changes in your DynamoDB tables to power live dashboards, generate metrics, and deliver data into data lakes. 
   - To easily monitor your database performance, DynamoDB is integrated with Amazon Cloudwatch, which collects and processes raw database performance data.

Amazon DynamoDB provides:

- Eventual Consistent Reads (default)
- Strongly Consistent Reads

For Provisioned mode, you specify the number of reads and writes per second you expect your application to perform. DynamoDB will then reserve that capacity for you. It works at whatever capacity needed without any tweaks.

All data is stored on SSD storage and is spread across 3 different AZs.

### DynamoDB Anatomy

![DynamoDB Anatomy](./images/amazon-dynamodb-anatomy.png)

- Tables: Table contains rows and columns
- Items: The rows of data
- Attributes: Columns of data
- Keys: Identifying names of the data
- Values: The actual data

### Read Consistency

When data needs to be updated, it has to write updates to all the copies and data can be inconsistent when reading from a copy that has yet to be updated. The read consistency 
can be set ins DynamoDB to meet your needs.

#### Eventual Consistent Reads (default)

- When copies are being updated, it's possible for users to read and be returned the old data.
- The reads are fast but there is no guarantee that you will get the most recent data.
- All copies of data eventually become consistent within a second.

#### Strongly Consistent Reads

- When copies are being updates, an attempt to read the data will not return any result until all copies of the data are consistent.
- There is a guarantee of consistency but the trade off is higher latency(slow reads).
- All copies of data will be consistent within a second.

### Partitions

**Amazon DynamoDB** stores data in partitions. A partition is an allocation of storage for a table, backed by solid state drives (SSDs) and automatically replicated across 
multiple Availability Zones within an AWS Region. Partition management is handled entirely by DynamoDB—you never have to manage partitions yourself.

When you create a table, the initial status of the table is CREATING. During this phase, DynamoDB allocates sufficient partitions to the table so that it can handle your 
provisioned throughput requirements. You can begin writing and reading table data after the table status changes to ACTIVE.

DynamoDB allocates additional partitions to a table in the following situations:

- If you increase the table's provisioned throughput settings beyond what the existing partitions can support.
- If an existing partition fills to capacity and more storage space is required.

Each partition has a maximum of 3000 RCUs and 1000 WCUs (Write Capacity Units). DynamoDB even splits the RCUs and WCUs across all the partitions.

### Primary Keys

When you create a DynamoDB table, you have to define a Primary Key, the primary key determines where and how your data will be stored in partitions. The Primary Key cannot be 
changed later.

- **Partition Key**: determines which partition data should be writtent to
- **Sort Key**: determines how the data should be sorted within a partition

![DynamoDB Primary Key](./images/amazon-dynamodb-primary-key.png)

- Using only a Partition Key, is called a **Simple Primary Key**
- Using both a Partition Key and a Sort Key, is called a **Composite Primary Key**
- Amazon DynamoDB does not have a `Date` data type, so instead you have to use a string.

### Simple Primary Key

If your table has a simple primary key (partition key only), DynamoDB stores and retrieves each item based on its partition key value.

To write an item to the table, DynamoDB uses the value of the partition key as input to an internal hash function. The output value from the hash function determines the 
partition in which the item will be stored.

To read an item from the table, you must specify the partition key value for the item. DynamoDB uses this value as input to its hash function, yielding the partition in which 
the item can be found.

#### Example

The following diagram shows a table named Pets, which spans multiple partitions. The table's primary key is AnimalType (only this key attribute is shown). DynamoDB uses its 
hash function to determine where to store a new item, in this case based on the hash value of the string Dog. Note that the items are not stored in sorted order. Each item's 
location is determined by the hash value of its partition key.

![DynamoDB Simple Primary Key](./images/amazon-dynamodb-simple-primary-key.png)

### Composite Primary Key

To write an item to the table, DynamoDB calculates the hash value of the partition key to determine which partition should contain the item. In that partition, several items 
could have the same partition key value. So DynamoDB stores the item among the others with the same partition key, in ascending order by sort key.

To read an item from the table, you must specify its partition key value and sort key value. DynamoDB calculates the partition key's hash value, yielding the partition in which 
the item can be found.

You can read multiple items from the table in a single operation (Query) if the items you want have the same partition key value. DynamoDB returns all of the items with that 
partition key value. Optionally, you can apply a condition to the sort key so that it returns only the items within a certain range of values.

#### Example

Suppose that the Pets table has a composite primary key consisting of AnimalType (partition key) and Name (sort key). 

![DynamoDB Composite Primary Key](./images/amazon-dynamodb-composite-primary-key.png)

To read that same item from the Pets table, DynamoDB calculates the hash value of Dog, yielding the partition in which these items are stored. DynamoDB then scans the sort key 
attribute values until it finds Fido.

### DynamoDB Query

You must provide the name of the partition key attribute and a single value for that attribute. `Query` returns all items with that partition key value. Optionally, you can
provide a sort key attribute and use a comparison operator to refine the search results.

Use the `KeyConditionExpression` parameter to provide a specific value for the partition key. The `Query` operation will return all of the items from the table or index with
that partition key value. You can optionally narrow the scope of the `Query` operation by specifying a sort key value and a comparison operator in `KeyConditionExpression`. To
further refine the `Query` results, you can optionally provide a `FilterExpression`. A `FilterExpression` determines which items within the results should be returned to you. 
All of the other results are discarded.

A `Query` operation always returns a result set. If no matching items are found, the result set will be empty. Queries that do not return results consume the minimum number of 
read capacity units for that type of read operation.

`Query` results are always sorted by the sort key value. If the data type of the sort key is Number, the results are returned in numeric order; otherwise, the results are  
returned in order of UTF-8 bytes. By default, the sort order is ascending. To reverse the order, set the `ScanIndexForward` parameter to false.

A single `Query` operation will read up to the maximum number of items set (if using the `Limit` parameter) or a maximum of 1 MB of data and then apply any filtering to the 
results using `FilterExpression`. If `LastEvaluatedKey` is present in the response, you will need to paginate the result set.

`FilterExpression` is applied after a `Query` finishes, but before the results are returned. A `FilterExpression` cannot contain partition key or sort key attributes. You need 
to specify those attributes in the `KeyConditionExpression`.

By default, a `Query` operation uses eventually consistent reads when accessing the items in a table. However, you can use strongly consistent reads by setting the `ConsistentRead` parameter to true.

```sh
aws dynamodb query \
    --table-name Music \
    --key-condition-expression "Artist = :v_artist AND SongTitle = :v_song" \
    --expression-attribute-values file://expression-attribute-values.json \
    --projection-expression "AlbumTitle, Year" \
    --return-consumed-capacity TOTAL \
    --output json
```

Values.json:

```json
{
    "Artist": {
        "S": "No One Writes Songs Like You"
    },
    "SongTitle": {
        "S": "The Rolling Stones"
    }
}
```

### DynamoDB Scan

The Scan operation returns one or more items and item attributes by accessing every item in a table or a secondary index. To have DynamoDB return fewer items, you can provide a 
`FilterExpression` operation.

If the total size of scanned items exceeds the maximum dataset size limit of 1 MB, the scan completes and results are returned to the user. The `LastEvaluatedKey` value is also 
returned and the requestor can use the `LastEvaluatedKey` to continue the scan in a subsequent operation.

Each scan response also includes number of items that were scanned (`ScannedCount`) as part of the request. If using a `FilterExpression`, a scan result can result in no items 
meeting the criteria and the `Count` will result in zero. If you did not use a `FilterExpression` in the scan request, then `Count` is the same as `ScannedCount`.

A single Scan operation first reads up to the maximum number of items set (if using the `Limit` parameter) or a maximum of 1 MB of data and then applies any filtering to the 
results if a `FilterExpression` is provided. If `LastEvaluatedKey` is present in the response, pagination is required to complete the full table scan.

Scan operations proceed sequentially; however, for faster performance on a large table or secondary index, applications can request a parallel Scan operation by providing the 
Segment and `TotalSegments` parameters.

By default, a Scan uses eventually consistent reads when accessing the items in a table. Therefore, the results from an eventually consistent Scan may not include the latest 
item changes at the time the scan iterates through each item in the table. If you require a strongly consistent read of each item as the scan iterates through the items in the 
table, you can set the `ConsistentRead` parameter to true. Strong consistency only relates to the consistency of the read at the item level.

```sh
aws dynamodb scan \
    --table-name Music \
    --filter-expression "Genre = :v_genre" \
    --expression-attribute-values file://expression-attribute-values.json \
    --expression-attribute-names file://expression-attribute-names.json \
    --projection-expression "Artist, SongTitle, AlbumTitle" \
    --return-consumed-capacity TOTAL \
    --output json
```

Values.json:

```json
{
    ":v_genre": {
        "S": "Rock"
    }
}
```

Names.json:

```json
{
    "#yr": "Year",
    "#na": "Name"
}
```

Avoid DynamoDB scans as much as possiblee:

- Scans are much less efficient compared to running a query.
- As a table grows, scans take much longer tp complete.
- A large table can consume all the provisioned throughput in a single scan.


## Amazon Keyspaces

**Amazon Keyspaces (for Apache Cassandra)** is a scalable, serverless, and highly available managed database service compatible with Apache Cassandra. It allows you to run 
Cassandra workloads on AWS using existing CQL drivers and application code without managing infrastructure, offering instant scaling and automatic multi-AZ data replication.

- **Cassandra** is an open-source NoSQL key/value database similar to DynamoDB in that it is a columnar store database with some additional functionality. 
- **Keyspaces** is serverless with zero infrastructure management, zero downtime maintenance, instant scaling to any application demand, and pay-per-request billing.
- It supports applications that require virtually unlimited throughput and storage.
- Data is encrypted by default and Keyspaces enables you to back up your table data continuously using point-in-time recovery. Keyspaces gives you the performance, elasticity, 
and enterprise features you need to operate business-critical Cassandra workloads at scale.
- **Cluser** - A collection of nodes
- **Nodes** - holds up to 2-4 TB of data
  - All nodes read and write
  - Nodes represent the smallest unit of a database
  - Data is replicated on multiple nodes
- **Ring** - All nodes are arranged in a ring where all nodes connect to each other
- **Keyspace** - A namespace that specifies data replication on nodes
- **Table** - Tabular data of columns and rows with a primary key
- Cassandra is queried using the Cassandra Query Language (CQL)
- Interacting with Cassandra is typicallt done through an SDK, in your preferred programming language. 
- Amazon Keyspaces allows you to do the following using the AWS Management Console:
  - Create Keyspaces
  - Create Tables
  - Perform Queries using the CQL Editor

### Cassandra Query Language (CQL)

Cassandra Query Language (CQL) is a database query language for Apache Cassandra. It is a declarative language that is used to create, read, update, and delete data in a Cassandra database. CQL is a subset of SQL, but it is not a full implementation of SQL. CQL is a distributed database query language, and it is designed to be used with a distributed database. 

1. Create a Keyspace:
   
   ```sql
   CREATE KEYSPACE IF NOT EXISTS exampleKeyspace
   WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3};
   ```

2. Create Table:

    ```sql
    CREATE TABLE IF NOT EXISTS exampleKeyspace.users (
        user_id uuid PRIMARY KEY,
        first_name text,
        last_name text,
        email text
    );
    ```

3. Insert Data:

    ```sql
    INSERT INTO exampleKeyspace.users (user_id, first_name, last_name, email)
    VALUES (uuid(), 'John', 'Doe', 'johndoe@example.com');
    ```

4. Query Data:

    ```sql
    SELECT * FROM exampleKeyspace.users WHERE user_id = 123e4567-e89b-12d3-a456-426614174000;
    ```

5. Update Data:

    ```sql
    UPDATE exampleKeyspace.users 
    SET email = [EMAIL_ADDRESS]' 
    WHERE user_id = 123e4567-e89b-12d3-a456-426614174000;
    ```

6. Delete Data:

    ```sql
    DELETE FROM exampleKeyspace.users WHERE user_id = 123e4567-e89b-12d3-a456-426614174000;
    ```

## Amazon Neptune

**Amazon Neptune** is a fully managed, high-performance graph database service optimized for storing and querying highly connected datasets. It supports popular graph  
models—Property Graph (via Apache TinkerPop Gremlin/openCypher) and W3C RDF (via SPARQL)—making it ideal for social networking, fraud detection, recommendation engines, and  
knowledge graphs.

A **graph database** is a database composed of a data structure that uses vertices (nodes, dots) which form a relationship to other vertices via edges (arcs, lines).

Use cases for graph databases:

- Fraud detection
- Real-time recommendation engines
- Master data management (MDM)
- Network and IT operations
- Identity and Access Management (IAM)
- Traceability and Management
- Contact Tracing
- Data Lineage for GDPR
- Customer 360-degree analysis
- Product recommendations
- Social Media Graphing
- Feature engineering

### Amazon Neptune Analytics

Neptune Analytics is a memory-optimized graph database engine for analytics. With Neptune Analytics, you can get insights and find trends by processing large amounts of graph  
data in seconds. To analyze graph data quickly and easily, Neptune Analytics stores large graph datasets in memory. It supports a library of optimized graph analytic 
algorithms, low-latency graph queries, and vector search capabilities within graph traversals.

Neptune Analytics is an ideal choice for investigatory, exploratory, or data-science workloads that require fast iteration for data, analytical and algorithmic processing, or 
vector search on graph data. It complements Amazon Neptune Database, a popular managed graph database. To perform intensive analysis, you can load the data from a Neptune 
Database graph or snapshot into Neptune Analytics. You can also load graph data that's stored in Amazon S3.

It integrates with Workbench, and includes algorithms like PageRank, shortest path, and community detection directly applicable on the graph data. Leverages an Apache Spark 
cluster to perform complex analytics on the graph data.

### Amazon Neptune ML

Use Graph Nueral Networks (GNNs), a learning (ML) technique built for graphs, to make easy, fast, and more accurate using graph data. 
 - Powered by the open-source Deep Graph Library (DGL)
 - Neptune integrates with LangChain

### Amazon Neptune Database

Neptune database has two types:
  - Neptune Provisioned: You choose an instance type
  - Neptune Serverless: A serverless offering, you set a min and max Neptune Capacity Units (NCUs).

- Neptune database supports multi-AZ deployment.
- Netptune has two storage configurations:
  - **Neptune I/O optimized**: increased input/output for additional costs
  - **Neptune Standard**: 25% lower cost than I/O optimized
- You can create a Jupyter Notebook (within Amazon SageMaker Notebook) that includes magic extensions to easily work with Neptune database.
- Neptune Bulk Loader can be used to import large amounts of data.
- AWS has multiple built-in or third-party options for visualizing your graph database:
  - The open-source graph-explorer
  - Tom Sawyer Software
  - Cambridge Intelligence
  - Graphistry
  - Metaphacts
  - G.V()
  - Linkurious

### Gremlin

**Gremlin** is the grahp traversal language for Apache TinkerPop. Amazon Neptune is compatible with Apache TinkerPop and Gremlin. This means that you can connect to a Neptune 
DB instance and use the Gremlin traversal language to query the graph. 

A traversal in Gremlin is a series of chained steps. It starts at a vertex (or edge). It walks the graph by following the outgoing edges of each vertex and then the outgoing 
edges of those vertices. Each step is an operation in the traversal.

**Gremlin** is designed to the "Write Once, Run Anywhere" (WORA) principle. This means that you can write a Gremlin traversal once and run it on any graph database that is 
compatible with Apache TinkerPop and Gremlin. 

**Gremlin** traversal can be evaluated as:

- real-time database query (OLTP)
- batch analysis query (OLAP)

**Gremlin Host Language Embedding** means that you can write Gremlin traversals in your preferred programming language. 

### OpenCypher

**openCypher** is a declarative query language for property graphs that was originally developed by Neo4j, then open-sourced in 2015, and contributed to the openCypher project 
under an Apache 2 open-source license.

**Neptune** supports building graph applications using **openCypher**, currently one of the most popular query languages for developers working with graph databases. 
Developers, business analysts, and data scientists like openCypher’s SQL-inspired syntax because it provides a familiar structure to compose queries for graph applications.

**Cypher** is known for being more developer friendly for writing queries than using *Gremlin**. **Gremlin** is more proficient at traversal depending on the use-case.

```sql
# Creating
CREATE (a:Person {name: 'Alice', age: 30})
CREATE (b:Person {name: 'Bob', age: 25})
CREATE (a)-[:KNOWS {since: 2022}]->(b)

# Querying
MATCH (a:Person)
RETURN p.name, p.age

MATCH (a:Person {name: 'Alice'})-[:KNOWS]->(b:Person {name: 'Bob'})
RETURN a.name, b.name

# Updating
MATCH (a:Person {name: 'Alice'})
SET a.age = 31
RETURN a.name, a.age

# Advanced Query
MATCH (alice:Person {name: 'Alice'})-[:KNOWS]->(bob:Person)-[:KNOWS]->(friendsOfBob)
WHERE NOT (alice)-[:KNOWS]->(friendsOfBob)
RETURN friendsOfBob.name AS RecommendedFriend
```

### SPARQL

**`SPARQL`** is a query language for the Resource Description Framework (RDF), which is a graph data format designed for the web. Amazon Neptune is compatible with SPARQL 1.1.
This means that you can connect to a Neptune DB instance and query the graph using the query language described in the SPARQL Query Language specification.

**`SPARQL`** allows users to write queries against what can loosely be called "Key-value" data or, data that follows the RDF specification of the W3C. 

Setting up sample data:

```sql
@prefix : <http://example.org/> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .

:Alice a :Person ;
       :name "Alice" ;
       :age 24 ;
       :knows :Bob .

:Bob a :Person ;
     :name "Bob" ;
     :age 25 ;
     :knows :Charlie .

:Charlie a :Person ;
         :name "Charlie" .
```

Updating the data:

```sql
PREFIX : <http://example.org/>
DELETE {
  :Bob :age 22 .
}
INSERT {
  :Bob :age 23 .
}
WHERE {
  :Bob :age 22 .
}
```

Querying data:

```sql
PREFIX : <http://example.org/>
SELECT DISTINCT ?name
WHERE {
  :Alice :knows/:knows ?person .
  ?person :name ?name .
  FILTER NOT EXISTS {
    :Alice :knows ?person
  }
}
```

