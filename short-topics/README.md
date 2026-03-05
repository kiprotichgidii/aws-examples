## AWS Global Accelerator

**AWS Global Accelerator** is a networking service that improves the availability and performance of your applications for global users. It finds the optimal path from the end-user to target web-servers. It uses the AWS global network to route user traffic to the nearest healthy endpoint, such as an EC2 instance, Elastic Load Balancer, or Elastic IP address.

Global Accelerators are deployed within Edge Locations, so user traffic is sent to an Edge Location instead of directly to the target web-applications. This reduces latency and improves performance.

There two types of Global Accelerators:

- **Standard Global Accelerator**: Automatically routes traffic to the nearest healthy endpoint.
- **Basic Global Accelerator**: Routes traffic to specific endpoints.

![AWS Global Accelerator](./images/aws-global-accelerator.png)

1. **Listeners**: Listens for traffic on a specific port and sends traffic to an endoint group.
2. **Endpoint Groups**: A collection of endpoints within a specific AWS region. *Traffic Dials* can be used to change the traffic distribution percentage.
3. **Endpoints**: Represents resources to send traffic to. eg.
   - Network Load Balancer
   - Application Load Balancer
   - EC2 Instance
   - Elastic IP Address

**Global Accelerator** has a speed comparison tool, i.e `https://speedtest.globalaccelerator.aws/`

## AWS CloudFront

**CloudFront** is a content delivery network (CDN) service provided by Amazon Web Services (AWS). A **Content Delivery Network (CDN)** is a distributed network that delivers web pages and content to users based on their geographical location, the origin of the webpage, and a content delivery server.

**CloudFront** can be used to deliver:

- Static Content
- Dynamic Content
- Streaming Content
- Web Sockets

Amazon CloudFront can be fronted with AWS WAF for OWASP top 10 protection. Amazon CloudFront can stream videos on demand using ISS Microsoft Smooth Streaming.

![AWS CloudFront](./images/aws-cloudfront.png)

### CloudFront Core Components

1. **Origin**: Location where all of the original files are located. eg. an S3 bucket, EC2 Instance, ELB, or Route53
2. **Edge Location**: compute located strategically close to the end users.
3. **Regional Caches**: compute located in broad geographic locations to speed up requests for edge locations.
4. **Distribution**: A collection of edge locations and regional caches that define how cached content should be delivered.

![AWS CloudFront Core Components](./images/aws-cloudfront-components.png)

### CloudFront Lambda@Edge

**Lambda@Edge** is a serverless compute service that allows you to run code at the edge of the network. They are Lambda functions to override the default behavior of requests and responses. 

There are four functions for **Lambda@Edge**:

1. **Viewer Request**: When CloudFront receives a request from a viewer, it sends the request to the Lambda function.
2. **Viewer Response**: Before CloudFront sends a response to a viewer, it sends the response to the Lambda function.
3. **Origin Request**: Before CloudFront forwards a request to the origin, it sends the request to the Lambda function.
4. **Origin Response**: When CloudFront receives a response from the origin, it sends the response to the Lambda function.

![AWS CloudFront Lambda@Edge](./images/aws-cloudfront-lambda@edge.png)

#### Viewer Request Use Cases

- Redirecting HTTP to HTTPS
- Inspecting cookies for authentication
- Modifying headers for A/B testing

#### Viewer Response Use Cases

- Adding security headers
- Setting cookies for client-side tracking
- Customizing error messages

#### Origin Request Use Cases

- Rewriting URLs for SEO or routing
- Injecting headers for origin authentication
- Selective content serving based on user-agent 

#### Origin Response Use Cases

- Modifying headers to control acching
- Updating URLs in HTML for versioning
- Customizing error responses from the origin

**Lambda@Edge** functions support Python and Node.js. They are deployed at Regional Edge Caches.

#### Example Viewer Request Function

Redirecting HTTP to HTTPS:

```python
def lambda_handler(event, context):
    request = event['Records'][0]['cf']['request']
    # Perform operations on the request: Redirect HTTP to HTTPS
    if request['headers']['cloudfront-forwarded-proto'][0]['value'] == 'https':
        response = {
            'status': 301,
            'statusDescription': 'Moved Permanently',
            'headers': {
                'location': [
                    {
                        'key': 'Location',
                        'value': 'https://' + request['headers']['host'][0]['value'] + request['uri']
                    }
                ]
            }
        }
    # Return the original request for CloudFront to process
    return request
```

#### Example Viewer Response Function

Adding security headers:

```python
def lambda_handler(event, context):
    response = event['Records'][0]['cf']['response']
    # Perform operations on the response: Add security headers to the response
    headers = response['headers']
    headers['x-content-type-options'] = [
        {
            'key': 'X-Content-Type-Options',
            'value': 'nosniff'
        }
    ]
    headers['x-frame-options'] = [
        {
            'key': 'X-Frame-Options',
            'value': 'DENY'
        }
    ]
    headers['x-xss-protection'] = [
        {
            'key': 'X-XSS-Protection',
            'value': '1; mode=block'
        }
    ]
    # Return the modified response
    return response
```

#### Example Origin Request Function

Serving different version based on user-agent:

```python
def lambda_handler(event, context):
    request = event['Records'][0]['cf']['request']
    # Perform operations on the request: Serve different version based on user-agent
    user_agent = request['headers'].get('user-agent', [{'value': ''}])[0]['value']
    if 'mobile' in user_agent.lower():
        request['uri'] = '/mobile' + request['uri']
    else:
        request['uri'] = '/desktop' + request['uri']
    # Return the modified request
    return request
```

#### Example Origin Response Function

Change 404 to 200 and provide response body:

```python
def lambda_handler(event, context):
    response = event['Records'][0]['cf']['response']
    # Perform operations on the response: Check 404 status and modify the response
    if response['status'] == '404':
        response['status'] = '200'
        response['statusDescription'] = 'OK'
        response['body'] = 'Custom error page content'
        response['headers']['content-type'] = [
            {
                'key': 'Content-Type',
                'value': 'text/html'
            }
        ]
    # Return the modified response
    return response
```

### CloudFront Functions

**CloudFront Functions** are lightweight edge functions for high scale, latency-sensitive CDN customizations. CloudFront functions are cheaper, faster, but more limited compared to Lambda@Edge functions.

CloudFront functions have two `functions`:

1. **Viewer Request**: When CloudFront receives a request from a viewer, it sends the request to the Lambda function.
2. **Viewer Response**: Before CloudFront sends a response to a viewer, it sends the response to the Lambda function.

CloudFront functions are written in JavaScript and are deployed at Edge Locations. 

#### Use Cases

- Cache key normalization
- Header Manipulation
- Status code modification & body generation
- URL redirects or rewrites
- Request authorization

#### Example Viewer Request Function

Redirect HTTP to HTTPS:

```javascript
function handler(event) {
    var request = event.request;
    var headers = request.headers;
    // Check is viewer request is using HTTP
    if (request.uri.startsWith('http://')) {
        // Generate an HTTP redirect response to HTTPS
        var response = {
            statusCode: 301,
            statusDescription: 'Moved Permanently',
            headers: {
                "location": {
                    value: "https://" + headers.host.value + request.uri
                }
            }
        };
        return response;
    }
    return request;
}
```

#### Example Viewer Response Function

Add security headers:

```javascript
function handler(event) {
    var response = event.response;
    var headers = response.headers;
    // Add security headers to the response
    headers['x-content-type-options'] = {
        value: 'nosniff'
    };
    headers['x-frame-options'] = {
        value: 'DENY'
    };
    headers['x-xss-protection'] = {
        value: '1; mode=block'
    };
    headers['referrer-policy'] = {
        value: 'same-origin'
    };
    // Return the modified response
    return response;
}
```
### CloudFront Functions vs Lambda@Edge

| Feature | CloudFront Functions | Lambda@Edge |
| --- | --- | --- |
| **Programming Languages** | JavaScript (ECMAScript 5.1 compliant) | Python and Node.js |
| **Event Sources** | Viewer Request<br>Viewer Response | Viewer Request<br>Viewer Response<br>Origin Request<br>Origin Response |
| **Scale** | 10M+ requests per second | Up to 10K requests per second per region |
| **Function Duration** | Submillisecond | Up to 5 seconds( viewer request and response)<br>Up to 30 seconds (origin request and response) |
| **Max Memory** | 2MB | 128 - 3008 MB |
| **Max Size Function Code+Libs** | 10KB | 1MB (viewer request and response)<br>50MB (origin request and response) |
| **Network, File System, & Request Body Access** | No | Yes |
| **Geolocation and device data access** | Yes | No (viewer request)<br>Yes (viewer response, origin request & response) |
| **Build & Test within CloudFront** | Yes | No |
| **Function Logging & Metrics** | Yes | Yes |
| **Pricing** | Charged per request; Free tier available | Charged per request, function duration; No free tier |
| **Deployment** | Deployed at Edge Locations | Deployed at Regional Edge Caches |


![CloudFront Functions vs Lambda@Edge](./images/cloudfront-functions-vs-lambda@edge.png)

### CloudFront Origin

**CloudFront Origin** is the source where CloudFront will send requests for content that is not served from the cache. It can be an Amazon S3 bucket, an Amazon EC2 instance, or any other web server.

This information is provided when creating the CloudFront distribution.

```json
{
    "Origins": {
        "Quantity": 1,
        "Items": [
            {
                "Id": "awsexamplebucket.s3.amazonaws.com-cli-example",
                "DomainName": "awsexamplebucket.s3.amazonaws.com",
                "OriginPath": "",
                "CustomHeaders": {
                    "Quantity": 0
                },
                "S3OriginConfig": {
                    "OriginAccessIdentity": ""
                }
            }
        ]
    }
}
```

- **Domain Name**: the address to the origin.
- **Origin Path**: The path at the specified address to the origin.
- **Custom Headers**: The custom headers to be sent to the origin.
- **S3OriginConfig**: The S3 origin configuration.
  - Amazon S3
- **CustomOriginConfig**: The custom origin configuration.
  - AWS Elemental MediaStore Container
  - Application Load Balancer
  - Lambda function URL
  - HTTP server eg. Amazon EC2 instance
  - CloudFront Origins Group


## Amazon Elastic Block Store (EBS)

**What is IOPS?**

**IOPS** is an acronym for **Input/Output Operations Per Second**. It is the speed at which non-contagious reads and writes can be performed on a storage medium. The higher the IOPS, the faster the storage device can perform read and write operations. A high I/O = lots of small, fast read and writes.

**What is Throughput?**

**Throughput** is the transfer rate to and from the stoarge medium in megabytes per second (MBps).

**What is Bandwidth?**

**Bandwidth** is the maximum rate at which data can be transferred between two points in a network.

**What is EBS?**

**Elastic Block Store** is a highly available and durable block storage attaching persistent block storage volumes to Amazon EC2 instances. Volums are automatically replicated within their Availability Zone to protect against instance failure. 

Types of volumes that can be deployed:

- **General Purpose SSD (gp2)**: For general usage without specific requirements.
- **General Purpose SSD (gp3)**: Up to 20% cheaper per GB than **gp2**.
- **Provisioned IOPS SSD (io1)**: For very fast input/output operations.
- **Provisioned IOPS SSD (io2)**: For more durability than **io1**
- **io2 Block Express**: Higher throughput and IOPS with support for larger capacity.
- **Throughput Optimized HDD (st1)**: Magnetic drive optimised for quick throughput.
- **Cold HDD (sc1)**: Low cost HDD for infrequently accessed workloads.
- **Magnetic (standard)**: Precious generation HDD.

All **io2** volumes created after November 21, 2023 are **io2 Block Express volumes**. **io2** volumes created before November 21, 2023 can be converted to **io2 Block Express volumes**.

### EBS Volume Type Usage

| Feature | General Purpose SSD Volumes | Provisioned IOPS SSD Volumes  | Throughput Optimized HDD | Cold HDD | Magnetic |
| --- | --- | --- | --- | --- | --- |
| **Volume Type** |  <ul><li>gp2</li><li>gp3</li></ul> | <ul><li>io1</li><li>io2 Block Express</li></ul> | st1 | sc2 | standard |
| **Use Cases** | <ul><li>Transactional Workloads<li>Virtual Desktops<li>Medium-sized, single-instance databases<li>Low-latency interactice applications<li>Boot volumes<li>Development & testing environments</li></ul> | **io1** <ul><li>Large, in-memory databases</li><li>Mission-critical transactional databases</li><li>Other I/O intensive applications</li></ul><br>**io2 Block Express** <ul><li>Large, in-memory databases</li><li>Mission-critical transactional databases</li><li>Other I/O intensive applications</li></ul> | <ul><li>Big Data and analytics</li><li>Data warehouses</li><li>Log processing</li></ul> | <ul><li>Throughput-oriented storage for data that is infrequently accessed</li><li>Where lowest storage cost is important</li></ul> | <ul><li>Infrequently Accessed data workloads</li></ul> |
| **Durability** | 99.8% - 99.9% | **io1** 99.8% - 99.9%<br>**io2 Block Express** 99.999% | 99.8% - 99.9% | 99.8% - 99.9% | N/A |
| **Volume Size** | 1GiB - 16GiB | **io1** 4GiB - 16TiB<br>**io2 Block Express** 4GiB - 64TiB | 125 GiB - 16 TiB | 125 GiB - 16 TiB | 1 GiB - 1 TiB | 
| **Max IOPS** | 16,000 (16 KiB I/O)| **io1** 16,000 (16 KiB I/O)<br>**io2 Block Express** 256,000 (256 KiB I/O) | 500 (1 MiB I/O)| 250 (1 MiB I/O)| 40 - 200 (1 MiB I/O) |
| **Max Throughput** | **gp2** 250 MiB/s<br>**gp3** 1,000 MiB/s | **io1** 250 MiB/s<br>**io2 Block Express** 4,000 MiB/s | 500 (1 MiB/s)| 250 (1 MiB/s)| 40 - 90 (1 MiB/s |
| **EBS Multi-attach** | Not supported for either gp2 or gp3 | Supported for both io1 and io2 Block Express | Not Supported | Not Supported | N/A |
| **NVMe Reserve** | Not supported for either gp2 or gp3 | Supported only for io2 Block Express | N/A | N/A | N/A |
| **Boot Volume** | Supported for both gp2 and gp3 | Supported for both io1 and io2 Block Express | Not Supported | Not Supported | N/A |

### Hard Disk Drive (HDD) 

**HDD** is a magnetic storage device that uses rotating platters to, an actuator arm, and a magnetic head to read and write data(similar to a record player). **HDD** is very good at writing a continuous amount of data. **HDD** is not great for writing many small reads and writes. 

- Better for throughput
- Physical Moving Part

![EBS HDD](./images/aws-ebs-hdd.png)

#### RPMs (Revolutions Per Minute)

- The speed at which the drive's platters are spinning. Faster RPMs mean faster access times and slower RPMs mean better cost-savings.

##### 7200 RPM Drives

These are standard for desktops and high-performance external drives, offering a good balance of performance, cost and power consumption.

##### 5400 RPM Drives

These are commonly found in laptops, external drives, and applications where lower power consumption and heat are prioritized over top performance.

##### 10000 RPM Drives

These are typically used in enterprise environments, or high-end workstations where performance is critical. These drives have become less common due to the rise of Solid State Drives (SSDs).

#### HDD RAID

**RAID (Redundant Array of Independent Disks)** is a data storage virtualization technology that combines multiple physical disk drive components into one or more logical units for the purposes of storing redundant data across disks, performance improvement, or both. 

Since HDD has to do with mechanical parts, it is prone to failure, hence the need for RAID.

1. **RAID 0(stripping)**
   - No redundancy; data is split across disks for high performance.
   - It increases speed and capacity but offers no fault tolerance.
   - Requires a minimum of 2 disks.

2. **RAID 1(mirroring)**
   - Data is duplicated across 2 or more disks, offering high redundancy.
   - If one disk fails, the other disk(s) can be used to restore the data.
   - It increases fault tolerance but reduces capacity.
   - Requires a minimum of 2 disks.

3. **RAID 5(stripping with parity)**
   - Combines stripping and parity, spreading data across disks while also storing parity information.
   - It increases fault tolerance and capacity but reduces speed.
   - It can withstand the failure of one disk, without data loss.
   - Requires a minimum of 3 disks.

4. **RAID 6(stripping with double parity)**
   - Combines stripping and double parity, spreading data across disks while also storing parity information.
   - It can withstand the failure of two disks, without data loss.
   - Requires a minimum of 4 disks.

5. **RAID 10(1+0)**
   - Combines RAID 0(stripping) and RAID 1(mirroring), offering redundancy and increased performance.
   - Requires a minimum of 4 disks.

### Solid State Drive (SSD)

**SSDs** are much faster than HDDs because they use integrated circuit(IC) assemblies as memory to store data persistently, typically using flash memory chips. They are also more durable because they don't have any moving parts. However, they are more expensive than HDDs.

![EBS SSD](./images/aws-ebs-ssd.png)

**SSDs** are more resistant to physical shock and vibration than HDDs because they don't have any moving parts, hence run silently and have quicker access time and lower latency. This makes them ideal for use in laptops, tablets, and other portable devices.

- Very good frequent read/write operations
- No physical moving parts

#### SSD Types

1. **SATA SSDs**
   - Uses the SATA interface to connect to the motherboard.
   - Slower than NVMe SSDs but faster than HDDs due to the SATA interface limitations.
   - Good for general-purpose computing.

2. **NVMe SSDs**
   - Uses the PCIe interface for higher performance.
   - Much faster than SATA SSDs.
   - Ideal for intensive data tasks and gaming.
   - Available in M.2 or PCIe card form factors.

3. **M.2 SSDs**
   - Uses SATA or NVMe interfaces.
   - Compact, suitable for laptops and compact PCs.
   - Installed directly on the motherboard.

4. **U.2 SSDs**
   - Similar to M.2 NVMe SSDs but with a 2.5-inch form factor.
   - Designed for 2.5-inch drive bays.
   - Mainly used in enterprise and server environments.

5. **Portable SSDs**
   - External drives for easy portability
   - Uses the USB interface to connect to the motherboard.
   - Offers SSD speed and durability on the go.

6. **PCIe SSDs**
   - Add-on cards that provide high performance for older systems or specialized tasks.
   - Uses the PCIe interface to connect to the motherboard.

#### Serial Advanced Technology Attachment (SATA) SSDs

These are the most common and are compatible with the serial ATA interface, used by most desktop and laptop computers. They are relatively easy to install and offer good performance, though they are typically slower than their NVMe counterparts due to the limitations of the SATA interface.

![SATA SSD](./images/aws-sata-ssd.png)

#### Non-Volatile Memory Express (NVMe) SSDs

**NVMe SSDs** use the PCIe interface offering significantly higher performance compared to **SATA SSDs**. They are designed to take full advantage of the high speeds of flash-based torage technologies. **NVMe** drives are found in the form of M.2 SSDs but can also be added to a computer using PCIe expansions slot.

![NVMe SSD](./images/aws-nvme-ssd.png)

#### Peripheral Component Interconnect Express (PCIe) SSDs

These SSDs are add-on cards that fit into the PCI slot on the motherboard. They can offer high performance, especially in configurations that support NVMe. They are a good option for users looking to upgrade the storage of an older system or for specialized high-performance computing tasks.

PCIe slots on a motherboard come in different sizes, including x1, x4, x8, and x16. The larger the slot, the more data can be transferred between the SSD and the motherboard.

![PCIe SSD](./images/aws-pcie-ssd.png)

| PCIe slot generation | Releases | Max Bandwidth per lane | Max Bandwidth x16 Slot |
|----------------------|----------|------------------------|------------------------|
| PCIe 1.0             | 2003     | 250 MB/s               | 4 GB/s                 |
| PCIe 1.1             | 2005     | 250 MB/s               | 4 GB/s                 |
| PCIe 2.0             | 2007     | 500 MB/s               | 8 GB/s                 |
| PCIe 3.0             | 2010     | 1 GB/s                 | 16 GB/s                |
| PCIe 4.0             | 2017     | 2 GB/s                 | 32 GB/s                |
| PCIe 5.0             | 2019     | 4 GB/s                 | 64 GB/s                |
| PCIe 6.0             | 2022     | 8 GB/s                 | 128 GB/s               |

#### M.2 SSDs

**M.2 SSDs** are small, compact SSDs that are designed to fit into the M.2 slot on a motherboard. They are commonly used in laptops and other small form factor computers. M.2 SSDs can use either the SATA or NVMe interface.

#### U.2 SSDs

**U.2 SSDs** are similar in performance to M.2 NVMe SSDs but with a 2.5-inch form factor. They are designed for 2.5-inch drive bays and are mainly used in enterprise and server environments. They generally connect via a U.2 port.

![U.2 SSD](./images/aws-u2-ssd.png)

### Magnetic Tape

**Magnetic Tapes** are sequential access storage devices that use magnetic tape to store data. A tape drive is used to write data to the tape. Medium and large-sized data centers use magnetic tapes for long-term storage and backup purposes due to their low cost and high storage density. They normally come in the form of cassettes. 

- Durable for decades (good for at least up to 30 years)
- Cheap to produce

![Magnetic Tape](./images/aws-magnetic-tape.png)

## Amazon Elastic File System (EFS)

**Elastic File System** is a managed file storage service provided by Amazon Web Services (AWS). It is a fully managed, scalable, and highly available file storage service that can be used by multiple EC2 instances at the same time. It is based on the Network File System (NFS) protocol and is designed to work with Linux-based workloads. EFS is a good choice for workloads that require shared file storage, such as web servers, content management systems, and big data analytics.

- Storage capacity grows(up to petabytes) and shrinks automatically based on the data stored(elastic).
- **Multiple instances** in the **same VPC** can mount a **single EFS volume**.
- EC2 instances install the **NFSv4 client** to mount the EFS volume.
- EFS uses the Network File System version 4(**NFSv4**) protocol.
- EFS creates multiple mount targets in VPCs.
- EFS is charged per space used starting at $0.30 GB/month.

![EFS](./images/aws-efs.png)

### Amazon EFS Client

`amazon-efs-utils` package is an open-source collection of Amazon EFS tools also known as the Amazon EFS Client. It provides a set of tools to manage EFS volumes and mount targets.

- EFS client enables the ability to use Amazon CloudWatch to monitor an EFS file system's mount status.
- Amazon EFS client needs to be installed on the EC2 instance prior to mounting an EFS file system.

It includes the Amazon EFS mount helper, which makes it easier to mount EFS file systems. Mount helper is a program used when mounting a specific type of file system. EFS mount helper provides the following options:

- Mounting on supported EC2 instances
- Mounting with IAM authorization
- Mounting with Amazon EFS access points
- Mounting with an on-premise Linux client
- Auto-mounting EFS file systems when EC2 instances start
- Mounting file system when creating an new EC2 instance
- Mounting either Linux or MacOS

Amazon EFS does not support mounting from Amazon EC2 Windows instances. Before EFS mount helper, standard Linux NFS client was used to mount EFS file systems. 

