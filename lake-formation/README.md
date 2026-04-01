## AWS Data Lakes

A **data lake** is a centralized repository that allows you to store all your structured and unstructured data at any scale. You can store your data as-is, without having to
first structure the data, and run different types of analytics—from dashboards and visualizations to big data processing, real-time analytics, and machine learning to guide
better decisions.

Data Lakes are designed to store vast amounts of data. They generally use object(blobs) or files as the storage medium. 

- **Collect**: Pulling from various data sources.
- **Transform**: Change or blend data into new semi-structured data using ELT/ETL pipelines.
- **Distribution**: Allow acccess to data to various programs or APIs.
- **Publish**: Publish data sets to meta catalogs so analysts can quickly find useful data.

## AWS Lake Formation

**AWS Lake Formation** is a fully managed service that simplifies creating, securing, and managing data lakes on Amazon S3. It accelerates data lake setup by automating tasks
like ingestion, cleaning, and cataloging, while providing centralized, fine-grained access control (row/column level) across AWS analytics services.

It's a data lake to centrally govern, secure, and globally share data for analytics and machine learning. 

### Features

1. **Centralized Data Permissions**
   - Lake Formation centralizes permission management on your data resources in the AWS Glue Data Catalog, including databases and tables. You can define and manage access by
     role for your users and applications using familiar database-like grants, bringing the simplicity of data warehouses and databases to your data lake.
   - Lake Formation provides a single place to manage access controls for data in your data lake. You can define security policies that restrict access to data at the database
     table, column, row, and cell levels with fine-grained access control (FGAC).
   - AWS Lake Formation helps you consistently enforce permissions across  AWS analytics services  with native integrations for **Amazon Athena**, **Amazon SageMaker**, **Amazon
     Redshift**, as well as AWS Glue for data integration and Amazon EMR for big data processing.
   - Lake Formation is integrated with third-party partners so you can extend your permissions management to the engines you prefer, such as Starburst and Dremio. 

2. **Simplify security management and governance at scale**
   - Lake Formation makes it easier to scale permissions across users with tag-based access controls. With tag-based access controls, you can set attributes on data and apply
     permissions to those attributes to scale.
   - Lake Formation tags can be quickly populated with your own business rules and ontologies such as departments, product lines, data ownership, data sensitivity (for example
     public or private), and data classification (for example, Social Security Number, phone numbers). 

3. **Understand and Share Data**
   - Lake Formation lets you build permissions on databases and tables within the AWS Glue Data Catalog. This allows you to use the AWS Glue Data Catalog as a hub for managing
     and sharing your data. With AWS Glue Data Catalog federation features, you can extend permissions to data cataloged by your own Hive metastore or with Amazon Redshift data sharing.
   - With Lake Formation data sharing, you can directly control who you are sharing data with, such as selecting the exact IAM principals in other accounts to help ensure data
     ownership is controlled by the owner once it is shared.
   - AWS Lake Formation allows business-to-business data sharing external to your organization for licensing or other uses. Lake Formation integrates with AWS Data Exchange so
     you can share data with external businesses without moving or copying the data.
   - With Lake Formation permissions on the AWS Glue Data Catalog, users enjoy online, text-based search capabilities to provide them a better understanding of data within the
     AWS Glue Data Catalog.

4. **Monitor data access and help ensure compliance**
   - Lake Formation provides comprehensive audit logs with Amazon CloudTrail to monitor access and compliance with centrally defined policies. You can audit data access history
     across analytics and machine learning (ML) services that read the data using Lake Formation. This lets you see which users or roles have attempted to access what data and
     when. You can access audit logs in the same way you access other CloudTrail logs using the CloudTrail APIs and console.

### Use Cases

- Centralize permissions management for data resources, including databases and tables, from one place in the AWS Glue Data Catalog.
- Scale permissions across your users by setting attributes on data and applying attribute permissions.
- Encourage innovation by allowing users to quickly find, appropriately access, and share data with confidence in accordance with your goals and policies.
- Proactively address data challenges and protect your business with comprehensive data-access auditing.

## OpenAPI

**OpenAPI Specification(OAS)** defines a standard, language agnostic interface for RESTful APIs which allows both humans and computers to discover and understand the capabilities of the service without access to source code, documentation of through network traffic inspection.

**Swagger** and **OpenAPI** used to be the same thing but as of OpenAPI V3, they became two different things:
- OpenAPI = Specification
- Swagger = Tools for implementing the specification 

OpenAPI can be represented as either JSON or YAML.

```yaml
openapi: 3.0.0
info:
  title: Sample API
  version: 1.0.0
paths:
  /users:
    get:
      summary: Get all users
      responses:
        '200':
          description: A list of users
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  properties:
                    id:
                      type: integer
                    name:
                      type: string
```