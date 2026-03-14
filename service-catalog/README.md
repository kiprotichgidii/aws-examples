## AWS Service Catalog

**AWS Service Catalog** is a managed service that allows organizations to create and manage catalogs of products and services that are approved for use on AWS to achieve consistent governance and meet compliance requirements. It provides a simple and secure way to manage the lifecycle of IT services, from creation to retirement.

The **AWS Service Catalog** is an alternative to granting direct access AWS resources via the AWS console.

#### Advantages

1. Standardization 
2. Self-service discovery and launch
3. Fine-grained access control
4. Extensibility and version control

### Service Catalog Users

- **Administrative User**: Manages the catalog 
- **End Users**: Uses the service catalog to launch products

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

   
