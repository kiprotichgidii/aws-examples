## Amazon MQ

**Amazon MQ** is a managed message broker service for the open-source projects **Apache ActiveMQ** and **RabbitMQ**. It makes it easy to set up, operate, and scale message brokers in the cloud.

**Active MQ** is a powerful open-source messaging server that supports a wide range of protocols including AMQP, MQTT, STOMP, and JMS, offering robust features for JMS-centric, enterprise-integrated messaging scenarios. 

Amazon MQ Active MQ supports these protocols:
- AMQP 1.0
- MQTT
- STOMP
- NMS
- JMS
- WebSocket

**Rabbit MQ** is a highly reliable, scalable, and flexible messaging broker that supports advanced messaging protocols like AMQP, MQTT, and STOMP, making it ideal for complex routing scenarios and high-throughput requirements.

Amazon MQ RabbitMQ supports AMQP 0-9-1.

Amazon MQ has a similar offering to SQS however MQ can handle more complex delivery rules with different performance guarantees. 

| Feature | RabbitMQ | ActiveMQ |
| --- | --- | --- |
| **Protocol Support** | AMQP, MQTT, STOMP | AMQP, MQTT, STOMP, OpenWire |
| **Performance** | Generally considered faster and more efficient in scenarios with lightweight messages and high throughput | Good performance, Slower under high load compared to RabbitMQ.<br>Offers more features which can add overhead.|
| **Message Routing** | Advanced message routing capabilities with exchange types like direct, topic, headers, and fanout. | Basic message routing capabilities with more emphasis on JMS standards.|
| **Transaction Support** | Basic transaction support | Advanced support for JMS transactions.|
| **Flexibility Support** | Highly flexible due to support for multiple messaging protocols and extensive client library support. | Flexible, especially with Java environments due to JMS. <br> Offers a broad range of connectors for different systems. |

### AMQP

