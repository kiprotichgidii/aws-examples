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

