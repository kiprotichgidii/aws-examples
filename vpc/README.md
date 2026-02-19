## AWS Virtual Private Cloud (VPC)

AWS Virtual Private Cloud is a logically isolated virtual network. A VPC resembles a traditional network that you'd operate in your own data center.

![AWS VPC](./images/aws-vpc.png)

A VPC provides many different networking components. A virtual Machine, i.e EC2 is the most common reason that a user would need a VPC in AWS. 

Virtual Network Cards, i.e, Elastic Network Interface(ENI) are used within a VPC to attach to different compute types e.g, EC2, Lambda, ECS.

AWS Virtual Private Cloud is tightly coupled with AWS EC2, and all VPC CLI command are under `aws ec2`, so technically, you can't separate VPC from EC2 even though they are treated as two different things in the console.

### Core Components of AWS VPC

A VPC is composed of many different networking components and here are the main ones:
1. **Internet Gateway (IGW)**: A gateway that connects a VPC to the public internet
2. **Virtual Private Gateway (VPN Gateway)**: A gateway that connects a VPC to a private external network
3. **Route Tables**: A set of rules that determine where to route traffic in a VPC
4. **NAT Gateway**: A gateway that allows private instances (e.g EC2 instances) to connect to services outside of the VPC
5. **Network Access Control Lists (NACLs)**: Acts as a stateless virtual firewall for compute within a VPC. It operates at the subnet level with allow and deny rules.
6. **Security Groups (SG)**: Acts as a stateful virtual firewall for compute instances within a VPC. It operates at the instance level with allow rules.
7. **Public Subnets**: Subnets that allow instances to have public IP addresses.
8. **Private Subnets**: Subnets that disallow instances to have public IP addresses.
9. **VPC Endpoints**: Privately connect to AWS support services.
10. **VPC Peering**: Connecting VPCs to other VPCs.

Technically, NACLs and SGs are EC2 networking components, but as mentioned earlier, you can't really separate VPC from EC2.

### VPC Key Features

- VPCs are region specific. You can use VPC Peering to connect VPCs across regions.
- You can create upto 5 VPCs per region. (adjustable)
- Every region comes with a default VPC.
- You can have upto 200 subnets per VPC.
- You can have upto 5 IPv4 CIDR blocks per VPC.
- You can have upto 5 IPv6 CIDR blocks per VPC.
- Most VPC components don't incur any charges from AWS, e.g
  - VPC itself, Route Tables, NACLs, Internet Gateways, Security Groups, Subnets, and VPC Peering.
- Here's what has additional charges from AWS:
  - VPC Endpoints, VPN Gateway, Customer Gateway
  - IPv4 addresses, Elastic IPs.
- DNS hostnames

### Default VPC

AWS has a default VPC in every region, so you can immediately deploy instances. 

A default VPC is configured with:
- An IPv4 CIDR block at the address 172.31.0.0/16, with 65,536 IP addresses available
- A subnet size of `/20` for each AZ, with 4096 IP addresses available
- An Internet Gateway
- A default Security Group
- A default Network Access Control List(NACL)
- A default DHCP options set
- A route table with a route to the public internet via an Internet Gateway

A defaut VPC can be deleted, but AWS recommends that you do not, and instead use the default VPC.

If you accidentally delete the default VPC, it can be recreated via the CLI, using the following command:

```bash
aws ec2 create-default-vpc --region us-east-1
```
- A deleted VPC cannot be restored.
- You cannot mark an existing non-default VPC as a default VPC and if you already have a default VPC in a region, you canoot create another one.

###  Deleting a VPC

To be able to delete a VPC, you need to ensure that all the VPC resources have been deleted prior to that. e.g
- Security Groups and Network ACLs
- Subnets
- Route Tables
- Gateway Endpoints
- Internet Gateways
- Egress-Only Internet Gateways (EO-IGWs)

When a VPC is deleted in the AWS Console, it will automatically attempt to delete all the VPC resources associated with that VPC.

### Default Route / Catch-all-route

The default route represents all the IP addresses. It gives access from anywhere or to the internet without restriction.

IPv4 default route: `0.0.0.0/0`

IPv6 default route: `::/0`

When `0.0.0.0/0` is specified as the default route in a route table for the Internet Gateway, it allows all internet access. When `0.0.0.0/0` is specified in a Security Group's inbound Rules, it allows all traffic from the internet to access the public resources.

### Shared VPC

AWS Resource Access Manager allows you to share resources across your AWS accounts. VPCs can be shared with other AWS accounts within the same account to centrally manage resources in a single VPC. 

Using a shared VPC allows you to:
- Reduce the number of VPCs you create and manage
- Separate accounts for billing and access control

In order to share a VPC you need to establish sharing within your AWS organization via the RAM api:

```bash
aws ram enable-sharing-with-aws-organization
```
- You share VPCs by sharing subnets.
- You can ony share non-default subnets
- You need to create a resource share in RAM (what you are sharing)
- You need to create a shared principles in RAM (who you are sharing with)

Shared VPC will appear in the shared account with the specific share subnets. You can tell if it's shared by looking at the OwnerID.

### Introduction to NACls (Network Access Control Lists)

NACLs act as a stateless virtual firewall at the subnet level. NACLs have both ALLOW and DENY Rules, unlike Security Groups, which only have ALLOW rules.

A default NACL is created with every new VPC.

Each NACL has two different sets of rules:
- Inbound Rules (Ingress traffic)
- Outbound Rules (Egress traffic)

Subnets are associated with NACLs and a subnet can only belong to a single NACL.

They key difference of NACLs from Security Groups is that NACLs have both ALLOW and DENY rules, while Security Groups only have ALLOW rules. With NACLs, you could block a single IP address, which you can't do with Security Groups.

NACL rules have NACL numbers, which determine the order of evaluation from the lowest to the highest. The highest rule # can be 32766 and it's recommended to work in 10 or 100 increments.

With NACL rules, you can set a type of traffic or set up a custom Protocol and Port range. You can either allow or deny traffic for a specific rule.

#### Creating NACLs

User creates the NACL rule:

```bash
aws ec2 create-network-acl \
  --vpc-id vpc-1234abcd5678efgh 
```

Then adds a NACL entry rule:

```bash
aws ec2 create-network-acl-entry \
  --network-acl-id acl-1a2b3c4d5e6f7h789a \
  --ingress \
  --rule-number 100 \
  --protocol tcp \
  --port-range From=80,To=80 \
  --cidr-block 0.0.0.0/0 --rule-action allow
```

Then associate the NACL to a subnet:

```bash
aws ec2 replace-network-acl-association \
  --association-id aclassoc-1a2b3c4d5e6f7890a \
  --network-acl-id acl-1a2b3c4d5e6f7890ab
```
