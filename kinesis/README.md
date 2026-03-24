## AWS Kinesis

**Amazon Kinesis** is a fully managed AWS service designed to ingest, process, and analyze real-time streaming data at massive scale. It acts as a high-speed conveyor belt for
data, enabling live dashboards, instant alerts, and real-time analytics for IoT telemetry, application logs, and video.

Streaming Data Examples:

- Stock Prices
- Game Data
- Social Network Data
- Geospatial Data
- Click Stream Data

There are 4 different types of Kinesis Streams:

1. **Kinesis Data Streams**
   - A real-time data sreaming service.
   - Configure custom producers and consumers.
   - The most flexible data streaming option.
2. **Amazon Kinesis Firehose**
   - A serverless and simpler version of Data Streams.
   - Integrates directly to specific AWS services.
   - You pay-on-demand based on how much data consumed.
3. **Managed Service for Apache Fink**
   - Allows users to run queries against data running through their streams.
   - Reports and analysis can be created on emerging data.
4. **Kinesis Video Streams**
   - Allows users to analyze or apply processing on real-time streaming video.

### Kinesis Data Streams

**Amazon Kinesis Data Streams (KDS)** is a fully managed, serverless, real-time data streaming service that ingests and stores large volumes of data (such as IoT telemetry, logs,
and clickstreams) from multiple sources. It allows for real-time processing and analysis by multiple consumers, with data retained for 1 to 365 days, ensuring durability across
multiple Availability Zones.

![Kinesis Data Streams](./images/aws-kinesis-data-streams.png)

**Kinesis Data Streams** has two capacity modes:

- On Demand
- Provisioned

