## Amazon ElastiCache

**Amazon ElastiCache** is a fully managed, in-memory data store and caching service provided by Amazon Web Services (AWS). It supports Redis OSS, Valkey, and Memcached engines to boost application performance—achieving microsecond latency—by storing frequently accessed data in memory rather than slower disk-based databases. It is widely used for real-time applications and caching.

It provides a high-performance, scalable, and cost-effective caching solution.  At the same time, it helps remove the complexity associated with deploying and managing a distributed cache environment. **ElastiCache** is intended to cache data or HTML fragments to greatly improve response time in 10s to 100s of milliseconds. 

- ElastiCache is only accessible by resources in the same VPC to ensure low latency.
- ElastiCache can be deployed in multiple AZs for high availability
- ElastiCache can be deployed on-prem via AWS Outposts
- ElastiCache can use RBAC for Redis 6.0+ so users managed user access via the AWS management console
- ElastiCache can be replicatd cross-region via ElastiCache Global Datastores
- Users can reserve nodes to save money with ElastiCache Standard
- ElastiCache can be automate to perform backups of data stores

![ElastiCache](./images/aws-elasticache.png)

### Deployment Options

ElastiCache supports two deployment modes:

1. ElastiCache (standard)
2. ElastiCache Serverless

| | Serverless | Standard |
| --- | --- | --- |
| Use Case | Unpredictable workloads | Predictable Workloads |
| Management | Automatically Scales | Customer Manages Cluster and Nodes |
| Billing | Data stored<br>ElastiCache Processing Units (ECPU) consumed | Number of node<br>Type of node(size) |

Standard can be deployed on-prem via AWS Outposts.

### Caching Options

1. **Memcached**
   - It is a simple key/value store.
   - Generally preferred for caching HTML fragments.
   - The trade off to being simple, is that is very fast.

2. **Redis**
   - Can perform complex operations on data.
   - It's very good for leaderboards and keeping track of unread notification data.
   - It's very fast, but arguably not as fast as Memcached.

