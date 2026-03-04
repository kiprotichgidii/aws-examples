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
|


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

