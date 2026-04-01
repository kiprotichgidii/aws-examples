## Amazon API Gateway

**Amazon API Gateway** is an AWS service for creating, publishing, maintaining, monitoring, and securing REST, HTTP, and WebSocket APIs at any scale. It acts as a "front door"
for applications to access data, business logic, or functionality from backend services like AWS Lambda, Amazon EC2, or any web-accessible endpoint. API developers can create
APIs for use in their own client applications.

![Amazon API Gateway Architecture](./images/amazon-api-gateway-architecture.png)

API Gateway creates RESTful APIs that:

- Are HTTP-based.
- Enable stateless client-server communication.
- Implement standard HTTP methods such as GET, POST, PUT, PATCH, and DELETE.

There are three types of API Gateways:

1. REST API(API Gateway V1)
   - Complete control over requests and response
   - Most feature-rich
   - Higer costs
   - Both private and public APIs

2. HTTP API(API Gateway V2)
   - Low latency
   - Simple feature set
   - Low costs
   - Only Public APIs

3. WebSocket API
  - Persistent connections for real-time use cases such as chat applications or visualization dashboards.

For both REST and HTTP APIs, developers can import an OpenAPI 3 file when creating an API:

```yaml
openapi: 3.0.0
info:
  title: My API
  version: 1.0.0
  description: My Example API
paths:
  /hello:
    get:
      summary: Returns a greetings message
      responses:
        '200':
          description: A Greetings Message
          content:
            application/json:
              schema:
                type: object
                properties:
                  message:
                    type: string
                    example: Hello, World!
```

Importing via CloudFormation:

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  # API Gateway REST API
  MyApi:
    Type: AWS::ApiGateway::RestApi
    Properties:
      Name: MyExampleApi
      Description: API Gateway for Lambda integration
      Body:
        'Fn::Transform':
          Name: AWS::Serverless-2016-10-31
          Parameters:
            Location: !Sub 'S3://${BucketName}/openapi.yaml'
```

### OpenAPI Extensions for AWS

AWS Extends the OpenAPI definitions so you can define AWS API Gateway specific features in an OpenAPI file.

Syntax: `x-amazon-apigateway-extension`

- `any-method` object
- `-cors` object
- `-api-key-source` property
- `-auth` object
- `-authorizer` object
- `-authtype` object
- `-binary-media-types` property
- `-documentation` object
- `-endpoint-configuration` object
- `-gateway-responses` object
- `-gateway-responses.gatewayResponses` object
- `-gateway-responses.responseParameters` object
- `-gateway-responses.responseTemplates` object
- `-importexport-version`
- `-tag-value` property
- `-integration` object
- `-integrations` object
- `-integration.requestTemplates` object
- `-integration.requestParameters` object
- `-integration.response` object
- `-integration.responses` object
- `-integration.responseParameters` object
- `-integration.responseTemplates` object
- `-integration.tlsConfig` object
- `-minimum-compression-size`
- `-policy`
- `-request-validator` property
- `-request-validators` object
- `-request-validators.requestValidator` object

#### Examples

1. Example using the `-policy` extension to define IAM Policy for API Paths:

   ```yaml
   ---
   x-amazon-apigateway-policy:
     Version: '2012-10-17'
     Statement: 
     - Effect: Allow
       Principal: "*"
       Action: execute-api:Invoke
       Resource: 
       - execute-api:/*
     - Effect: Deny
       Principal: "*"
       Action: execute-api:Invoke
       Resource: 
       - execute-api:/*
       Condition: 
         IpAddress:
           aws:SourceIp: 
           - 192.0.2.0/24
   ```

2. Example using the `-cors` extension to define CORS for the API:

   ```yaml
   --- 
   x-amazon-apigateway-cors:
     corsConfiguration:
       allowOrigins:
         - "https://example.com"
       allowCredentials: true
       allowHeaders:
         - x-apigateway-header
         - x-amz-date
         -content-type
       allowMethods:
         - "GET"
         - "POST"
         - "OPTIONS"
       exposeHeaders:
         - x-apigateway-header
         - x-amz-date
         -content-type
       maxAge: 300
   ```
