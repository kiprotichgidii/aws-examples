## AWS Service Catalog

**AWS Service Catalog** is a managed service that allows organizations to create and manage catalogs of products and services that are approved for use on AWS to achieve consistent governance and meet compliance requirements. It provides a simple and secure way to manage the lifecycle of IT services, from creation to retirement.

The **AWS Service Catalog** is an alternative to granting direct access AWS resources via the AWS console.

#### Advantages

1. Standardization 
2. Self-service discovery and launch
3. Fine-grained access control
4. Extensibility and version control

### Service Catalog Architecture

![AWS Service Catalog](./images/aws-service-catalog-users.png)

1. **Portfolio**
   - A container for products, permissions and constraints.
2. **Product**
   - A CloudFormation template or a set of templates that define the resources to be provisioned.
3. **Permissions**
   - Who can view and launch products.
4. **Constraints**
   - A constraint is a rule that is applied to a provisioned product.
5. **Catalog**
   - A user-friendly console to view and launch products.
6. **Provisioned Product**
   - A provisioned product is a product that has been launched by a user.
   - They are CloudFormation stacks.
7. **Service Actions**
   - SSM documents that can be executed on the stacks.

### Service Catalog Users

There are two types of catalog users:

1. **Catalog Administrator**: Manages the catalog 
2. **End Users**: Uses the service catalog to launch products

#### Catalog Administrator

A **Catalog Administrator** manages a catalog of products and services, organizing them into portfolios and controlling access to end users. An administrators technical responsibilities include:

- Preparing CloudFormation templates
- Configuring constraints
- Managing IAM roles assigned to products

#### End Users

**End Users** use the AWS Management Console to launch products that the administartors have granted them access to.

### Administrator Product

A **product** is a CloudFormation template that defines the resources that will be launched.

```yaml
Resources:
  MyEC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-0c55b159cbfafe1f0
      InstanceType: t2.micro
      Tags:
        - Key: Name
          Value: MyEC2Instance
```

- Users can create or associate an AWS Budget to a product.
- Once a product is created, it cannot be deleted, but only edited.
- A product must be removed from the portfolio and not provisioned by a user in order to delete.
- In order for products to be visible to end users, they must be added to a portfolio.
