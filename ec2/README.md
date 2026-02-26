## Amazon Elastic Compute Cloud (EC2)

Elastic Compute Cloud (EC2) is a web service that provides a secure, highly configurable virtual server. EC2's simple web-service interface allows you to provide orientation, capacity, and configuration for virtual servers in the cloud. With AWS, you can launch an instance in minutes. Anything and everything on AWS uses EC2 instances underneath.

![AWS EC2](./images/aws-ec2.png)

### Cloud-Init

Cloud-init is the industry standard multi-distribution method for cross-platform cloud instance initialization. It is supported across all major public cloud providers, provisioning systems for cloud instance initialization package. It is used to initialize cloud instances on first boot. It can be used to install software, configure the instance, and set up the instance for use.

Cloud Instance Initialization is the process of preparing an instance with configuration data for the operating system and runtime environment. It is used to install software, configure the instance, and set up the instance for use.

![AWS Cloud-Init](./images/aws-cloud-init.png)

Cloud Instances are initialized from a disk image and instance data:
- Metadata
- User-data
- Vendor-data

User Data is a script that is run when the instance is first launched. It can be used to install software, configure the instance, and set up the instance for use.


### EC2 User Data

A script can be provided to the EC2 UserData to have cloud-init automatically run it at firt-boot. You can either provide a script or a cloud-config file. 

#### User Data Bash Script Example

```bash
#!/bin/bash

# Update the package list
apt-get update

# Install Nginx
apt-get install -y nginx

# Start Nginx
systemctl start nginx

# Enable Nginx to start on boot
systemctl enable nginx

# Write a simple HTML file
echo "Hello World" > /var/www/html/index.html
```
Scripts must be base64 encoded when directly using the API, the AWS CLI and Cloud Console will automatically encode the script to base64.

#### User Data Cloud-Config Example

```yaml
#cloud-config
package_update: true
package_upgrade: true
packages:
  - nginx
runcmd:
  - systemctl start nginx
  - systemctl enable nginx
  - echo "<html><h1>Hello World</h1></html>" > /var/www/html/index.html
```

Via the AWS CLI, you can pass the script directly or via a file:

```bash
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --count 1 \
  --instance-type t2.micro \
  --security-group-ids sg-12345678901234567 \
  --subnet-id subnet-12345678901234567 \
  --key-name my-key \
  --user-data file://user-data.sh
```

OR, you can provide the script inline:

```bash
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --count 1 \
  --instance-type t2.micro \
  --security-group-ids sg-12345678901234567 \
  --subnet-id subnet-12345678901234567 \
  --key-name my-key \
  --user-data "#!/bin/bash
apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<html><h1>Hello World</h1></html>" > /var/www/html/index.html"
```
### EC2 Meta Data

EC2 metadata information can be accessed from the instance itself using the Metadata Service (MDS) via a special endpoint. There are two versions of the Metadata Service: 

- **Instance Metadata Service Version 1 (IMDSv1)**: a request/response method
- **Instance Metadata Service Version 2 (IMDSv2)**: a session-oriented method

IMDSv2 was implemented after an exploit of IMDSv1 was discovered. IMDSv2 adds defense in depths attackes against open firewalls, reverse proxies, and SSRF vulnerabilities.

The endpoint address:
- IPv4: `http://169.254.169.254/latest/meta-data/`
- IPv6: `http://fd00:ec2::254/latest/meta-data/`

IMDSv1 using curl:

```bash
curl ttp://169.254.169.254/latest/meta-data
```

IMDSv2 using curl:

```bash
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/
```
Instance metadata is grouped into categories, and there are over 60+ categories of instance metadata. Some of the categories are:

- `ami-id`
- `ami-launch-index`
- `ami-manifest-path`
- `ancestor-ami-ids`
- `autoscaling/target-lifecycle-state`
- `block-device-mapping/ami`
- `block-device-mapping/ebsN`
- `block-device-mapping/ephemeralN`
- `block-device-mapping/root`
- `block-device-mapping/swap`
- `elastic-gpus/associations/elastic-gpu-id`
- `elastic-inference/associations/eia-id`
- `events/maintenance/history`
...

There are configuration options you can configure around metadata:
- You can enforce the use of tokens (IMDSv2)
- You can turn off the endpoint all together
- You can specify the amount of network hops allowed

### EC2 Instance Types

The instance type naming convention is as follows:

![AWS EC2 Instance Types](./images/aws-ec2-instance-types.png)

Some parts of the instance type may be omitted, eg. `t3.micro` does not contain Processor Family or Additional Capacity.

### EC2 Instance Families

Instance families are different combinations of CPU, Memory, Storage, and Networking capacity. Instance families allow you to choose the appropriate combination of capacity to meet your workload requirements. Different instance families are different because of the varying hardware used to give them their unique properties.

#### Instance Family Types

1. **General Purpose**
   - A1, T2, T3, T3a, T4g, M4, M5, M5a, M5n, M6zn, M6g, M6i, Mac
   - This instance family types offers a balance of compute, memory, and networking resources. 
   - **Best for**: Web servers, development environments, and general-purpose workloads.

2. **Compute Optimized**
   - C4, C5, Cba, C5n, C6g, C6gn
   - This instance family types are ideal for compute-intensive applications that benefit from high-performance processors. 
   - **Best for**: Scientific modeling, dedicated gaming servers, and server engines

3. **Memory Optimized**
   - R4, R5, R5a, ,R5b, R5n, X1, X1e, High Memory, z1d
   - This instance family types provides high performance for workloads that process large datasets in memory. 
   - **Best for**: In-memory caches, In-memory databases, and real-time big data analytics

4. **Accelerated Optimized**
   - P2, P3, P4, G3, G4ad, G4dn, F1, Inf1, VT1
   - This instance family types are ideal for hardware accelerators or co-processors such as Graphics Processing Units (GPUs).
   - **Best for**: Machine learning, computational finance, siesmic analysis, and speech recognition

5. **Storage Optimized**
   - I3, I3en, D2, D3, D3en, H1
   - This instance family types are ideal for high, sequential read and write access to very large datasets on local storage.
   - **Best for**: No-SQL, In-memory or transactional databases, and data warehousing

Often, Instance families are referred to as Instance Types, but an instance type is a combination of size and family.

- **C**: Compute Optimized
- **D**: Dense Storage
- **F**: Field Programmable Gate Array (FPGA)
- **G**: Graphics Intensive 
- **Hpc**: High Performance Computing
- **Im**: STorage Optimized with a 1:4 (vCPU:Memory) ratio
- **Is**: STorage Optimized with a 1:6 (vCPU:Memory) ratio
- **Inf**: AWS Inferentia
- **M**: General Purpose
- **Mac**: Apple MacOS
- **P**: GPU Accelerated
- **R**: Memory Optimized
- **T**: Burstable Performance
- **Trn**: AWS Trainium
- **U**: High Memory
- **VT**: Video Transcoding
- **X**: Memory Intensive

