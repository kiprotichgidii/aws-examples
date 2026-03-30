## Amazon CodeGuru

**Amazon CodeGuru** is a suite of machine learning developer tools designed to improve code quality and application performance through intelligent recommendations. It offers two main components: **CodeGuru Reviewer** (for automated code reviews in Java and Python) and **CodeGuru Profiler** (to optimize runtime performance, identify bottlenecks, and reduce infrastructure costs).

CodeGuru has three services:

- CodeGuru Security - detect, track, and fix code security issues
  - Code Security Analysis Scan
  - Code Quality Analytics Scan
  - Secrets Detection Scan
- CodeGuru Profiler - optimize runtime performance, identify bottlenecks, and reduce infrastructure costs
- CodeGuru Reviewer - associate a repo for continous code change recommendations
  - GitHub Actions is used to automate continous checks for GitHub repositories.

CodeGuru supports the following languages:
 - Java
 - JavaScript
 - Python
 - C#
 - TypeScript
 - Ruby
 - Go
 - IaC
   - CloudFormation
   - Terraform
   - AWS SDK (TypeScript, Python)

## Amazon Comprehend

**Amazon Comprehend** is a fully managed, natural language processing (NLP) service that uses machine learning to extract insights, sentiment, and entities from text without requiring prior ML expertise. It processes documents, customer feedback, and social media to identify topics, languages, and sensitive data (PII).

Amazon Comprehend can analyze text and extract the following:
- **Entities** - eg. Person, Organization, Location
  !
- **Key Phrases** - Text that appear important eg. <u>Pay</u> the amount of <u>$220.00</u> by <u>August 8th</u>.
- **Language** - confidence of the language being spoken eg. English
- **Personal Identifiable Information (PII)** - eg. Social Security Number, Email Address, Phone Number
- **Sentiment** - eg. Positive, Negative, Neutral, Mixed
- **Targeted Sentiment** - Specific words and their attitude eg. Awful 1.0 Negative
- **Syntax** - Identify parts of a language.
- **Custom Models** - upload training data to analyze and extract custom text
  - **Amazon Comprehend Flywheel** - automate the training of model versions fos custom models

- Amazon Comprehend is serverless, you pay based on the size of the requests, in units. eg. 1 unit = 100 characters.
- Real-time analysis can be peformed via an endpoint.
- Analysis jobs allow for batch jobs.

The primary way of using Amazon Comprehend is via the AWS SDK:

Example for analyzing text for language and sentiment using Ruby:

```ruby
require 'aws-sdk-comprehend'

client = Aws::Comprehend::Client.new(region: 'us-east-1')
text = "Hello World, this is Gedion Kiprotich from Kenya. I am a DevOps engineer and I am passionate about automation."

# Detect the dominant language
language_response = client.detect_dominant_language(text: text)
language_code = language_response.languages.max_by(&:score).language_code
puts "Dominant Language: #{language_code}"

# Detect sentiment
sentiment_response = client.detect_sentiment({
  text: text, 
  language_code: language_code
})

# Print the sentiment analysis results
puts "Sentiment: #{sentiment_response.sentiment}"
puts "Positive: #{sentiment_response.sentiment_scores.positive}"
puts "Negative: #{sentiment_response.sentiment_scores.negative}"
puts "Neutral: #{sentiment_response.sentiment_scores.neutral}"
puts "Mixed: #{sentiment_response.sentiment_scores.mixed}"
```
## Amazon Forecast

**Amazon Forecast** is a fully managed AWS service that uses machine learning (ML) to deliver highly accurate time-series forecasts without requiring prior ML experience. It automates data preparation, model training, and tuning to predict business metrics like inventory demand, workforce staffing, and financial, based on historical data and related variables (e.g., weather, holidays).

You need to upload your dataset to S3 with:
- Historical Data
- Additional Metadat (Optional)

### Amazon Forecast Workflow

1. Create a Data Set Group / Create a Data Import Job
   - Define teh schema
   - Register the task
2. Create Predictor / Get Accurate Metrics
   - ELT Job evaluates the model
     - Choose a predefined backtest
3. Create Forecast
   - Deploy the predictor
   - Retrain with full dataset
4. Query Forecast / Export Forecast

Amazon Forecast will produce a visual graph:

![Amazon Forecast](images/amazon-forecast-visual-graph.png)

## Amazon Fraud Detector

**Amazon Fraud Detector** is a fully managed fraud detection service that automates the detection of potentially fraudulent activities online. These activities include unauthorized transactions and the creation of fake accounts. Amazon Fraud Detector works by using machine learning to analyze your data. It does this in a way that builds off of the seasoned expertise of more than 20 years of fraud detection at Amazon.

You upload your dataset for data model training to an S3 bucket which will then be referenced by Fraud Detector. 

**Amazon Fraud Detector** comes with the following predefined models, which you'll train your data against:
- **Online Fraud Insights**: Optimized to detect fraud when little historical data is available about the entity being evaluated. eg. New customers registering online for an account.
- **Transaction Fraud Insights**: Testing fraud use cases where the e ntity that is being evaluated might a history of intercations that the model cqn analyze to improve prediction accuracy.
- **Account Takeover Insights**: If an account was compromised by phishing attacks or any other type of attack.

Using the AWS SDK, real-time fraud detection systems can be architected using AWS Step Functions, Amazon Kinesis, AWS Lambda and other AWS Application integration services. 

To create a model:
- Choose the Model Type eg. Online Fraud Insights
- Choose the data sources eg. S3
- Define the data schema
  - Define the label mapping
- Define the Model variables to be used

```python
import boto3
fraudDetector = boto3.client('frauddetector')

fraudDetector.create_model_version(
  modelId = 'sample_fraud_detection_model',
  modelType = 'ONLINE_FRAUD_INSIGHTS',
  trainingDataSource = 'EXTERNAL_EVENTS',
  trainingDataSchema = {
    'modelVariables': [
      'ip_address',
      'email_address'
    ],
    'labelSchema': {
      'labelMapper': {
        'FRAUD': ['fraud'],
        'LEGIT': ['legit']
      }
      unlabeledEventsTreatment': 'AUTO'
    }
  },
  externalEventsDetail = {
    'dataLocation' : 's3://bucket-name/file.csv'
    'dataAccessRoleArn' : 'role_arn' 
  }
)    
```

After reviewing mode performance, we set it to active to deploy the model for real-time detection.

```python
import boto3
fraudDetector = boto3.client('frauddetector')

fraudDetector.update_model_version_status(
  modelId = 'sample_fraud_detection_model',
  modelType = 'ONLINE_FRAUD_INSIGHTS',
  modelVersionNumber = '1.0.0',
  status = 'ACTIVE'
) 
```

### Fraud Detector Components

![Amazon Fraud Detector](images/amazon-fraud-detector-components.png)

- **Models**: ML models that are trained on your data to detect fraud.
- **Thresholds**: Thresholds are used to determine the risk level of a given event. 
- **Scores**: Numerical values that represent the risk level that a given event is being fraudulent. Different models use different scoring.
- **Rules**: The decision logic that interprets the model’s risk score. Rules determine the final outcome (e.g., Approve, Review, Reject)
  - Variable or List - What data to operate on
  - Expression - rule language eg. operators, regex
  - Outcome - the outcome return
- **Detector**: A detector is a container for models, rules, and outcomes. 
- **Outcomes**: The actionable result of a rule eg.
  - risk levels (high_risk, medium_risk, low_risk)
  - actions (approve, review)

To define an event type, you need to define Labels, Entities, and Variables.

![Amazon Fraud Detector](images/amazon-fraud-detector-event-type.png)

- **Labels**: Classify an event as fraudulent or legitimate, used to train supervised machine learning models.
- **Entities**: Represents the doer of the event eg. Customer
- **Variables**: Data elements extracted from the event, such as email address, IP address, phone number, or transaction amount.

Events contain the data and rules that will be analyzed by the model.

## Amazon Kendra

Amazon Kendra is a fully managed, machine-learning search engine service that uses natural language processing (NLP) and machine learning to find answers within large, decentralized data repositories. It enables organizations to index unstructured/semi-structured data (PDFs, docs, Wikis) across various sources (S3, SharePoint, Google Drive) to provide accurate, context-driven search results.

Instead of key-word matching, Amazon Kendra uses semantic and contextual understanding to search a query. It's like interacting with a human expert who can understand the context of your question and provide a relevant answer. Amazon Lex Chatbot can be used as an interface to Amazon Kendra.

Amazon Kendra has the following components:
- **Index**: A table that holds the index of documets to make them searchable.
- **Data Source**: Where the documents are stored. eg. S3, Sharepoint, Box, Postgres, you need to define a schema
  - **Data Source Template Schemas**: AWS Provides around 40 schema templates for common AWS Services or third party cloud storage services.
- **Document Addition API**: An API to add documents directly to an index.

Amazon Kendra has two versions which provide all features but with different limitations:

| Feature | Developer Edition | Enterprise Edition |
| --- | --- | --- |
| 5 indexes with up to 5 data sources each | 5 indexes with up to 50 data sources each |
| 10K documents or 3GB of extracted text | |
| 4K queries per day or 0.05 queries per second | 8K queries per day or 0.1 queries per second |
| Runs in 1 AZ | Runs in 3 AZs |
 
The Developer Edition has free tier with upto 750hrs first 30 days.

1. Create Index:

   ```sh
   aws kendra create-index \
     --name my-index \
     --description "My Index" \
     --role-arn arn:aws:iam::123456789012:role/KendraIndexRole
   ```
2. Create Data Source:
   
   ```sh
   aws kendra create-data-source \
     --index-id index-id \
     --name my-data-source \
     --role-arn arn:aws:iam::123456789012:role/KendraDataSourceRole \
     --type S3 \
     --configuration '{"S3Configuration": {"BucketName": "bucket-name"}}'
  # different data source would use a template to define the schema
  # --type TEMPLATE \
  # --configuration '{"TemplateConfiguration": {"TemplateId": {JSON Schema}}}'
  ```
3. Sync the data source to the Index (update the index):

   ```sh
   aws kendra start-data-source-sync-job \
     --index-id index-id \
     --id data-source-id
   ```
4. Query Kendra index for results:

   ```sh
   aws kendra query \
     --index-id index-id \
     --query-text "What is the capital of France?"
   ```
