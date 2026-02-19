## AWS Virtual Private Cloud

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

