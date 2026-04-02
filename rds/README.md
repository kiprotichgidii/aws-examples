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

Multi-AZ Instance deployment is for Amazon RDS instances. For example, a Multi-AZ DB instance deployment, where Amazon RDS automatically provisions and maintains a synchronous standby replica in a different Availability Zone. The replica database doesn't serve read traffic.

![Multi-AZ Instance Deployment](./images/amazon-rds-multi-az-instance-deployment.png)

#### Multi-AZ Cluster Deployment

Multi-AZ Cluster deployment is for Amazon Aurora DB clusters. For example, a Multi-AZ DB cluster deployment, which has a writer DB instance and two reader DB instances in three separate Availability Zones in the same AWS Region. All three DB instances can serve read traffic.

![Multi-AZ Cluster Deployment](./images/amazon-rds-multi-az-cluster-deployment.png)

Multi-AZ deployment offer Autoatic Failover protection. In case of a failover, RDS will automatically failover to the secondary DB instance. The failover process can take up to 60 seconds.

