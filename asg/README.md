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

### ASG Health Check Replacements

**Health Check Replacement** is when an ASG replaces instances that have been determined to be unhealthy. There are two types of health checks: 
- **EC2 Health Checks**: If the EC2 instance fails either of it's EC2 health checks, the ASG will replace it.
- **ELB Health Checks**: ASG will perform a health check based on the ELB health check. ELB pings a HTTP endpoint at a specific path, port and status code.

```bash
aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name <asg-name> \
  --health-check-type ELB \
  --health-check-grace-period 300 \
  --vpc-zone-identifier "subnet-0123456789abcdef0, subnet-0123456789abcdef1, subnet-0123456789abcdef2"
```

![ASG Health Check Replacement](./images/aws-asg-health-check-replacement.png)

### ASG ELB Integration

An Elastic Load Balancer can be attached to an Auto Scaling Group (ASG):

```bash
aws autoscaling attach-load-balancer-target-groups \
  --auto-scaling-group-name <asg-name> \
  --target-group-arns <target-group-arn> \
  --target-group-port 80
```

![ASG ELB Integration](./images/aws-asg-elb-integration.png)

An attached ELB means that the ASG will use the ELB health checks to determine if an instance is healthy. 

### ASG Dynamic Scaling Policies

**Dynamic Scaling Policies** are how much ASGs should change the capacity. They allow you to automatically adjust the size of an ASG based on demand. There are three dynamic scaling policies:

- **Simple Scaling**: A single CloudWatch alarm triggers a single scaling action.
- **Step Scaling**: A CloudWatch alarm triggers a scaling action based on the size of the alarm breach.
- **Target Tracking Scaling**: A CloudWatch alarm triggers a scaling action to maintain a target value for a metric.

Adjustment types determine how capacity should change (only applicable to Simple and Step Scaling):
- **ChangeInCapacity**: Change capacity based on the scaling adjustment
- **ExactCapacity**: Change capacity to an exact number
- **PercentChangeInCapacity**: Change capacity by a percentage

### Simple Scaling Policy

**Simple Scaling Policies** simply change capacity in either direction by a certain amount when a CloudWatch alarm is triggered.
 
Create the scale-in/scale-out policies:

```bash
# Scale Out
aws autoscaling put-scaling-policy \
  --auto-scaling-group-name  my-asg \
  --policy-name my-simple-scale-out-policy \
  --scaling-adjustment 30 \
  --adjustment-type PercentageChangeInCapacity 

# Scale In
aws autoscaling put-scaling-policy \
  --auto-scaling-group-name my-asg \
  --policy-name my-simple-scale-in-policy \
  --scaling-adjustment -1 \
  --adjustment-type ChangeInCapacity \
  --cooldown 300
```

Create the CloudWatch alarms:

```bash
# Scale Out
aws cloudwatch put-metric-alarm \
  --alarm-name my-simple-scale-out-alarm \
  --alarm-description "Scale out when CPU > 70%" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 60 \
  --evaluation-periods 2 \
  --threshold 70 \
  --comparison-operator GreaterThanThreshold \
  --alarm-actions <scale-out-policy-arn> \
  --dimensions Name=AutoScalingGroupName,Value=my-asg \
  --unit Percent
```

```bash
# Scale In
aws cloudwatch put-metric-alarm \
  --alarm-name my-simple-scale-in-alarm \
  --alarm-description "Scale in when CPU < 30%" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 60 \
  --evaluation-periods 2 \
  --threshold 30 \
  --comparison-operator LessThanThreshold \
  --alarm-actions <scale-in-policy-arn> \
  --dimensions Name=AutoScalingGroupName,Value=my-asg \
  --unit Percent
```

When using Simple Scaling Policies, it is recommended to set a cooldown period. The cooldown period is the amount of time that the ASG should wait before performing another scaling action after a scaling action has been performed. 

It also not recommended to use **Simple Scaling Policies** and cooldown periods together, and instead opt for **Step Scaling Policies** or **Target Tracking Scaling Policies**.