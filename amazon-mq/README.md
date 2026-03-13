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

### Advance Message Queueing Protocol (AMQP)

**AMQP** is an open standard wire-level protocol for message-oriented middleware. It is a messaging protocol that enables applications to communicate with each other by sending and receiving messages. AMQP is a reliable, flexible, and widely supported protocol that is used in a variety of applications.

![Amazon AMQP](./images/aws-amqp.png)

- Messages are published to **Exchanges**
- **Exchanges** route message copies to **Queues** using rules called **bindings**
- The **Broker** pushes messages to subscribed **Consumers**, or the consumer pull messages from the queue
- Messages can have **metadata** attached to them
- Messages are only removed from the queue when a consumer ACKs(acknowledges) the broker. 

There are four types of exchanges:
- **Direct (Default)**: Routes messages to queues based on a routing key
- **Topic**: Routes messages to queues based on a topic pattern
- **Fanout**: Routes messages to all queues
- **Headers**: Routes messages to queues based on message headers

#### Example

AWS Ruby SDK has a library called bunny which is RabbitMQ client that uses the AMQP protocol.

Publishing to a queue example:

- Create a channel
- Create or set a queue
- Get an exchange
- Publish a message

```ruby
require 'bunny'
connection_string = "amqps://admin:Testing123456!@b-7cc94b99-4432-4a9c-ae14-9ab61199a0d7.mq.us-east-1.amazonaws.com:5671"
connection = Bunny.new(connection_string)
connection.start


channel = connection.create_channel
queue = channel.queue('hello')
exchange = channel.default_exchange


begin
    exchange.publish("Hello World!", routing_key: queue.name)
    channel.close
    connection.close
rescue => e
    puts e.inspect
    channel.close
    connection.close
    exit(0)
end
```

Subscribing to a queue example:

```ruby
require 'bunny'


connection_string = "amqps://admin:Testing123456!@b-7cc94b99-4432-4a9c-ae14-9ab61199a0d7.mq.us-east-1.amazonaws.com:5671"
connection = Bunny.new(connection_string)
connection.start

channel = connection.create_channel
queue = channel.queue('hello')
begin
  queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts body
  end
rescue => e
    puts e.inspect
    channel.close
    connection.close
    exit(0)
end
```

### Message Queuing Telemetry Transport (MQTT)

**MQTT (MQ Telemetry Transport)** is a lightweight messaging protocol that is designed for use in constrained environments, such as the Internet of Things (IoT). It is a publish-subscribe protocol that is used to exchange messages between devices and applications.

**MQTT** uses minimal network bandwidth and is ideal for IoT devices with limited processing power and memory, or real-time messaging apps. It i suitable for machine-to-machine communication, remote monitoring, and event-driven applications.

![Amazon MQTT](./images/aws-mqtt.png)

- To publish or subscribe, an MQTT client is used
- A topic name is used to publish and subscribe eg. /hello/5/world


Publisher:

```ruby
require 'mqtt'

host = 'mqtts://admin:Testing123456!@b-6b39d23f-d358-4850-bfd4-a7784795fa05-1.mq.us-east-1.amazonaws.com:8883'
topic = 'test/topic'
message = "Hello World! MQTT"

begin
  MQTT::Client.connect(host) do |client|
    client.publish(topic,message)
  end
rescue =>  e
  puts e.inspect
end
```

Subscriber:
```ruby
require 'mqtt'

host = 'mqtts://admin:Testing123456!@b-6b39d23f-d358-4850-bfd4-a7784795fa05-1.mq.us-east-1.amazonaws.com:8883'
topic = 'test/topic'

begin
  MQTT::Client.connect(host) do |client|
    client.get(topic) do |topic, message|
      puts topic
      puts message
    end
  end
rescue =>  e
  puts e.inspect
end
```

### Simple Text Oriented Messaging Protocol (STOMP)

**STOMP (Simple Text Oriented Messaging Protocol)** is a simple, text-based messaging protocol that allows clients to communicate with almost any message broker. **STOMP** is so simple that it can be used with a telnet client. 

#### Example Publisher

```ruby
require 'stomp'

login = 'admin'
passcode = 'Testing123456!'
host = 'b-6b39d23f-d358-4850-bfd4-a7784795fa05-1.mq.us-east-1.amazonaws.com'
port = 61614

config = {
  hosts: [
    login: login, 
    passcode: passcode, 
    host: host, 
    port: port, 
    ssl: true
  ]
}

client = Stomp::Client.new(config)

dest = '/queue/test'
client.publish(dest,"Hello World! STOMP!")
client.close
```

#### Example Subscriber

```ruby
require 'stomp'

login = 'admin'
passcode = 'Testing123456!'
host = 'b-6b39d23f-d358-4850-bfd4-a7784795fa05-1.mq.us-east-1.amazonaws.com'
port = 61614

config = {
  hosts: [
    login: login, 
    passcode: passcode, 
    host: host, 
    port: port, 
    ssl: true
  ]
}

client = Stomp::Client.new(config)
dest = '/queue/test'
client.subscribe(dest) do |message|
  puts 'subbed'
  puts message
  client.acknowledge(message)
end
client.join
```
