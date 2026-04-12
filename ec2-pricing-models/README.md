## Amazon EC2 Pricing Models

### On Demand

**On Demand** is a pay-as-you-go pricing model that allows you to pay for the EC2 instances that you use, when you use them. There is no long-term commitment and you can scale 
your EC2 instances up or down as needed.

When you launch an EC2 instance on AWS, it is by default using On-Demand Pricing. On-Demand has no upfront payment and no long-term commitment is required. You are charged by 
the second, or the hour, per second for Linux, Windows, Windows with SQL Enterprise, Windows with SQL Standard, and Windows with SQL Web Instances that do not have a separate 
hourly charge. 

When looking up EC2 pricing, it will always show the price in hourly rates. 

On-Demand is for applications where the workload is for short-term, spikey, or unpredictable. When you have a new app, for development or you want to run experiments.

### Reserved Instances (RI)

Designed for applications that have a steady-state, predictable usage, or require reserved capacity. Reduced Pricing is based on Term X Class Offering X RI Attributes X Payment 
Option. 

1. **Term**
   - The longer the term, the greater the savings.
   - You commit to 1 year or 3 year contract.
   - Reserved instances do not renew automatically.
   - When they expire, the instance defaults to On-Demand, with no interruption to service.
2. **Class** - The less flexible the greater the savings.
   - *Standard* - Up to 75% reduced pricing compared to on-demand. You can modify RI attributes.
   - *Convertible* - Up to 54% reduced pricing compared to on-demand. You can exchange RIs for other RIs with different attributes.
3. **Payment Options** The greater the upfront payment, the greater the discount.
   - *No Upfront* - You are billed a discounted hourly rate for every hour within the term, regardless of whether ther Reserved Instance is being used. 
   - *Partial Upfront* - A portion of the cost must be paid upfront and the remaining hours in the term are billed at a discounted hourly rate.
   - *All Upfront* - Full payment is made at the start of the term.

RIs can be shared between multiple accounts within an AWS Organization unused RIs can be sold in the Reserved Instance Markeplace. 

### Reserved Instance Attributes

**RI Attributes** (aka Instance Attributes) are limited based on class offering and can affect final price of an RI instance. Thera are 4 RI Attributes: 

1. **Instance type**: For example, m4.large. This is composed of the instance family (for example, m4) and the instance size (for example, large).
2. **Region**: The region in which the Reserved Instance is purchased.
3. **Tenancy**: Whether your instance runs on shared (default) or single-tenant (dedicated) hardware.
4. **Platform**: The operating system eg. Windows or Linux/Unix.

### Regional and Zonal RI 

When you purchase a RI, you determine the scope of the Reserved Instance. The scope does not affect the price. 

| **Regional RI**: Purchase for a region | **Zonal RI**: purchase for an Availability Zone |
| Does not reserve capacity | Reserves capacity in the specified Availabilty Zone |
| RI discount applies to integrate to instance usage in any AZ in the Region | RI discount applies to instance in the selected AZ (no AZ Flexibility) |
| RI discount applies to instance usage within the instance family, regardless of size.<br> Only supported on Amazon Linux/Unix Reserved Instances within default tenancy. | No instance size flexibility. <br> RI discounts discount applies to instance usage for the specified instance type and size only. |
| You can queue purchases for regional RI. | |

### RI Limits

There is a limit to the number of reserved instances that you can purchase per month. 

Per month, you can purchase:

- 20 Regional Reserved Instances per Region.
- 20 Zonal Reserved Instances per AZ.

#### Regional Limits

- You cannot exceed your running On-Demand Instance limit by purchasing regional Reserved Instances.
- The default On-Demand Instance Limit is 20.
- Before purchasing RI ensure your On-Demand limit is equal or greater than your RI you intent to purchase.

#### Zonal Limits

- You can exceed your running On-Demand Instnace limit by purchasing Zonal Reserved Instances.
- If you already have 20 running On-Demand Instances, and you purchase 20 Zonal Reserved Instances, you can launch a further 20 On-Demand Instances that match the specifications of your zonal Reserved Instances.

### Capacity Reservations

EC2 instances are backed by different kind of hardware, and so there is a finite amount of servers available within  an Availability Zone per instance type or family. 

- You go to launch a specific type of EC2 instance but AWS has ran out of that server.

**Capcity Reservation** is a service of EC2 that allows you to request a reserve of EC2 instance type for a specific Region and AZ. The reserved capacity is charged at the selected instane type's On-Demand rate whether an instance is running in it or not.

You can also use your regional reserved instances with your Capacity Reservations to benefit from billing discounts. 

### Standard Vs Convertible RI

| Standard RI | Convertible RI |
| --- | --- |
| RI attributes can be modified: <br><ul><li>Change the AZ within the same region</li><li>Change the scope of the zonal RI to Regional RI or vice versa.</li><li>Change the instance size.</li><li>Change the network from Ec2-classic to VPC and vice versa.</li></ul> | RI attributes cannot be modified. |
| Cannot be exchanged. | Can be exchanged during the term for another Convertible RI with new RI attributes, including: <br><ul><li>Instance family</li><li>Change the instance Instance type</li><li>Platform</li><li>Scope</li></ul> |
| Can be bought or sold in the RI Marketplace. | Cannot be bought or sold in the RI Marketplace. |

### RI Marketplace

**EC2 Reserved Instance Marketplace** allows you to sell your unused Standard RI to recoup RI spend for RI you do not intend to or cannot use.
- Reserved Instances can be sold after they have been active for at least 30 days and once AWS has recieved the upfront payment (if any).
- You must have a US Bank account to sell Reserved Instances on the Reserved Instance Marketplace.
- There must be at least one month remaining in the term of the RI you are listing.
- You will retain the pricing and capacity benefit of your reservation until it's sold, and the transaction is complete.
- Your company name (and address upon request) will be shared with the buyer for tax purposes.
- A seller can set only the upfront price for a Reserved Instance. The usage price and other configuration (eg. instance type, AZ, platform) will remain the same as when the Reserved Instance was initially purchased.
- The term length will be rounded down to the nearest month. For example, a reservation with 9 months and 15 days remaining will appear as 9 months on the Reserved Instance Marketplace.
- You can sell up to $20,000 in Reserved Instances per year. If you need to sell more Reserved Instances.
- Reserved Instances in the GovCloud region cannot be sold on the Reserved Instance Marketplace.

### Spot Instances

- AWS has unused compute capacity that they want to maximize the utility of their idle servers. It's like when a hotel, offers bookings discounts to fill vacant suites or planes offer discounts to fill vacant seats.
- Spot instances provide a discount of 90% compared to On-Demand Pricing.
- Spot instances can be terminated if the computing capacity is needed by other On-Demand customers.
- Designed for applications that have flexible start and end times or applications that are only feasible at very low compute costs.
- AWS Batch is an easy convenient way to use Spot Pricing.
- Termination conditions:
  - Instances can be terminated by AWS at any time.
  - If your instance is terminated by AWS, you don't get charged for a partial hour of usage.
  - If you terminate an instance you will still be charged for any hour that it ran.

### Dedicated Instances 

Dedicated Instances is designed to meet regulatory requirements. When you have strict server-bound licensing that won't support multi-tenancy or cloud deployments you use 
Dedicated Hosts. 

When multiple customers are running workloads on the same hardware, Virtual Isolation is waht separates customers. When a Single customer has dedicated hardwar, physical 
isolation is what separates customers.

Dedicated can be offered for:
- On-Demand
- Reserved (up to 60% savings)
- Spot (up to 90% savings)

You can choose the tenancy when you launch an instance. 

Enterprise and Large Organizations may have security concerns or obligations about/against sharing the same AWS hardware with other AWS customers.

### AWS Savings Plan

**Savings Plan** offers you the similar discounts as Reserved Instances but simplifies the purchasing process. There are three types of savings plans:

- Compute Savings Plan
- EC2 Instance Savings Plan
- SageMaker Savings Plan

You can choose 2 differet terms:

- 1 year
- 3 year

You choose the following Payment Options:

- All Upfront
- Partial Upfront
- No Upfront

AWS Savings Plan has 3 different savings types:

1. **Compute**: 
   - Compute Savings Plan provides the most flexibility and reduce costs by uo to 66%. 
   - These plans automatically apply to EC2 instance usage, AWS Fargate, and AWS Lambda service usage regardless of instance family, size, AZ, region, OS, or Tenancy.

2. **EC2 Instances**: 
   - Provide the lowest prices, offering savings up to 72% in exchange for commitment to usage of individual instance families in a region. 
   - Automatically reduces your costs on the selected instance family in that region regardlessof AZ, size, OS, or tenancy.
   - Gives you the flexibility to change your usage between instances within a family in that region.

3. **SageMaker**: 
   - SageMaker Savings Plans helps you reduce SageMaker costs by up to 64%.
   - Automatically apply to SageMaker usage regardless of instance family, size, component, or AWS region.

