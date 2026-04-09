## Amazon Elatic Kubernetes Service(EKS)

**Amazon Elastic Kubernetes Service (EKS)** is a fully-managed, certified Kubernetes conformant service that simplifies the process of building, securing, operating, and 
maintaining Kubernetes clusters on AWS. Amazon EKS integrates with core AWS services such as CloudWatch, Auto Scaling Groups, and IAM to provide a seamless experience for 
monitoring, scaling, and load balancing your containerized applications.

![Amazon EKS](./images/amazon-eks-cloud.png)

For it's compute nodes, EKS supports the following:

- EC2 Instances
  - *Managed Node groups* - Autoscaling is fully managed by AWS.
  - *Self-managed node groups* - Customer can self-managed scaling using EC2 Auto Scaling Groups.
  - *Karpenter* - Cloud native open-source autoscaler.
- Fargate Instances
- External Instances (on premise)

You can connect and managed your cluster via `kubectl`. Use ALB to route traffic to your nodes via the AWS ALB Ingress Controller.

![Amazon EKS](./images/amazon-eks-cluster-architecture.png)

### EKS Add-Ons

**AWS Managed Add-Ons**

- **Amazon VPC CNI Plugin for Kubernetes**
  - Enable pod networking within your cluster.
- **CoreDNS**
  - Enable service discovery within your cluster.
- **Kube Proxy**
  - Enable service networking within your cluster.
- **Amazon EKS Pod Identity Agent**
  - Install EKS Pod Identity Agent to use EKS Pod Identity to grant AWS IAM permissions to pods through Kubernetes service accounts.
- Amazon Guard Duty Agent
- Amazon EBS CSI Driver
- Amazon EFS CSI Driver
- Mountpoint for Amazon S3 CSI Driver
- CSI Snapshot controller
- AWS Distro for OpenTelemetry
- Amazon CloudWatch Observability Agent

**Third Party Add-Ons**

- AccuKnox 
- NetApp
- Calyptia
- Cribl
- Dynatrace
- Datree
- Datadog
- GroundCover
- Grafana Labs
- HA Proxy
- Pow
- KubeCost
- Kasten
- Kong
- LeakSignal
- New Relic
- Rafay
- Solo.io
- StormForge
- Splunk
- Teleport
- Tetrate
- Upbound Universal Crossplane
- Upwind

### EKS Connector

You can use **Amazon EKS Connector** to register and connect any conformant Kubernetes cluster to AWS and visualize it in the Amazon EKS console. After a cluster is connected, 
you can see the status, configuration, and workloads for that cluster in the Amazon EKS console. You can use this feature to view connected clusters in Amazon EKS console, but 
you can’t manage them.

The Amazon EKS Connector can connect the following types of Kubernetes clusters to Amazon EKS.

- On-premises Kubernetes clusters
- Self-managed clusters that are running on Amazon EC2
- Managed clusters from other cloud providers

You install the EKS Connector via helm in your target cluster:

```sh
helm -n eks-connector install eks-connector \
  oci://public.ecr.aws/eks-connector/eks-connector-chart \
  --set eks.activationCode="your_activation_code" \
  --set eks.activationId="your_activation_id" \
  --set eks.agentRegion="your_region"
```

### EKS CTL

`eksctl` is a command-line utility tool that automates and simplifies the process of creating, managing, and operating Amazon Elastic Kubernetes Service (Amazon EKS) clusters. 
Written in Go, eksctl provides a declarative syntax through YAML configurations and CLI commands to handle complex EKS cluster operations that would otherwise require multiple 
manual steps across different AWS services.

