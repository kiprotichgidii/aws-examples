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

