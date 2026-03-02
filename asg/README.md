## Auto Scaling Group (ASG)

An **Auto Scaling group (ASG)** is a collection of EC2 instances that are managed by AWS Auto Scaling. The ASG automatically adjusts the number of EC2 instances in the group based on demand. 

Auto Scaling helps you maintain application availability and lets you automatically adjust the number of EC2 instances in response to changing demand. You can use Auto Scaling to automatically scale your Amazon EC2 capacity up or down to meet demand, or on a schedule. Auto Scaling can also automatically replace unhealthy instances with new ones.

![AWS Auto Scaling Group](./images/aws-auto-scaling-group.png)

Automatic scaling can occur via: 
- **Capacity Settings**: manually setting the expected range of capacity
- **Health Check Replacements**: instances are replaced if they are determined to be unhealthy. Uses EC2 and ELB health checks.
- **Scaling Policies**: set complex rules to determine when to scale up or down 
  - Simple Scaling
  - Step Scaling
  - Target Tracking Scaling
  - Predictive Scaling

ASGs are used to scale **EC2** instances. **ECS** with **EC2** will work, **EKS** with **EC2** will work, but **ECS** with **Fargate** and **EKS** with **Fargate** will not work because Fargate is a serverless container orchestration service.

### ASG Use Cases

![AWS ASG Use Cases](./images/aws-asg-use-cases.png)

1. Burst of traffic hits our domain
2. Route53 points that traffic to our Load Balancer
3. The Load Balancer passes the traffic to it's target group
4. The target group is associated with our ASG and sends the traffic to instances registered to the ASG 
5. The ASG Scaling Policy will check if the instances are near capacity 
6. The Scaling Policy determines that another instance is needed and launches a new EC2 instance with the associated launch configuration to the ASG

### ASG Capacity Settings

The size of an autoscaling group is determined by the following settings:
- **Desired Capacity**: the number of EC2 instances that should ideally be running
- **Minimum Size**: the minimum number of EC2 instances that should at least be running
- **Maximum Size**: the maximum number of EC2 instances that are allowed to be running

To update min size and max size of an ASG:

```bash
aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name <asg-name> \
  --min-size <min-size> \
  --max-size <max-size>
```
To update desired capacity of an ASG:

```bash
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name <asg-name> \
  --desired-capacity <desired-capacity>
  --honor-cooldown
```
An ASG will always launch instances to meet the minimum size capacity. Changing the min, maxz and desired capacities is considered "manual scaling", since you have to manually change these numbers to change the capacity of the ASG. 
