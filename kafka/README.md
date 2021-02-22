## DevOpsLab
### Set Kafka (Stream monitoring system) in one single-node installation

This example of Kafka implementation must not be used in a production environment as it is not securely configured.
The purpose of this lab is shown the concepts of Stream, Topic, Producer and Consumer in a Kafka arquitecture.

Project structure:
```
.
└── docker-compose.yaml
└── README.md
```

[_docker-compose.yaml_](docker-compose.yaml)
```
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:latest
    ...
  kafka:
    image: confluentinc/cp-kafka:latest
    ...
```
[_docker-compose-elk.yaml_](docker-compose-elk.yaml)
```
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:latest
    ...
  kafka:
    image: confluentinc/cp-kafka:latest
    ...
  elasticsearch:
    image: elasticsearch:7.8.0
    ...
  logstash:
    image: logstash:7.10.1
    ...
  kibana:
    image: kibana:7.8.0
    ...
  filebeat:
    image: elastic/filebeat:7.10.2
    ...
```
Alternatively, you could use the images in bitnami/kakfa or in wurstmeister/zookeeper

## Deploy with docker-compose
When using only the kafka installation
```
$ docker-compose up -d
Creating network "kafka" with driver "bridge"
Creating zookeeper ... done
Creating kafka_broker ... done
$
```

When using with elk integration
```
$ docker-compose -f docker-compose-elk.yml up -d
Creating network "kafka" with driver "bridge"
Creating zookeeper ... done
Creating kafka_broker ... done
Creating elasticsearch ... done
Creating logstash ... done
Creating kibana ... done
Creating filebeat ... done
$
```

## Expected result

If everything is OK, you must see two containers running and the port mapping as displayed below (notice container ID could be different):
```
$ docker ps
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS                    PORTS                                                                                            NAMES
345a3e0f0b5b        zookeeper:6.0.1      "/usr/local/bin/dumb…"   11 seconds ago      Up 2 seconds             0.0.0.0:2181->2181/tcp                                                                           zoo
fd3f0b35b448        kafka:6.0.1          "/usr/local/bin/dumb…"   11 seconds ago      Up 2 seconds             0.0.0.0:9092->9092/tcp                                                                           broker
$
```
or if with elk integration, four aditional containers will be shown
```
$ docker ps
CONTAINER ID  IMAGE                 COMMAND                 CREATED         STATUS                 PORTS                                                NAMES
345a3e0f0b5b  zookeeper:6.0.1       "/usr/local/bin/dumb…"  11 seconds ago  Up 2 seconds           0.0.0.0:2181->2181/tcp                               zoo
fd3f0b35b448  kafka:6.0.1           "/usr/local/bin/dumb…"  11 seconds ago  Up 2 seconds           0.0.0.0:9092->9092/tcp                               broker
45e9b302d0f0  elasticsearch:7.8.0   "/tini -- /usr/local…"  12 seconds ago  Up 2 seconds (healthy) 0.0.0.0:47321->9200/tcp, 0.0.0.0:49156->9300/tcp     els
164f0553ed54  logstash:7.8.0        "/usr/local/bin/dock…"  13 seconds ago  Up 1 seconds           0.0.0.0:5000->5000/tcp, 0.0.0.0:5044->5044/tcp, 0.0.0.0:9600->9600/tcp, 0.0.0.0:5000->5000/udp   logstash
fd3f0b35b448  kibana:7.8.0          "/usr/local/bin/dumb…"  14 seconds ago  Up 2 seconds           0.0.0.0:5601->5601/tcp                               kibana
e2f3bacd4f46  filebeat:latest        "/usr/local/bin/dock…" 12 seconds ago  Up 1 seconds           0.0.0.0:                                             filebeat
a4f767a4b3c2  nginx:latest          "/docker-entypoint…"    12 seconds ago  Up 1 seconds           0.0.0.0:4000->4000/tcp                               nginx
$ 
```
Then, you can launch each application using the below links in your local web browser:

* Kafka: [`http://localhost:9092`](http://localhost:9092)
* For the ELK stack, please see how to verify in [https://github.com/JuanLuisGozaloFdez/DevOpsLab/blob/main/elk/README.md](https://github.com/JuanLuisGozaloFdez/DevOpsLab/blob/main/elk/README.md)

Stop and remove the containers
```
$ docker-compose down
$
```

## How to test this Kafka implementation
Remember that Kafka is a stream processing system (a broker) between Producers and Consumers.

The best way to test the system is open TWO terminals in your docker KAFKA container: one will play the role of Producer and the other for Consumer.

To open the terminals, you need to enter inside the container (using *'docker ps'* you can see the container-id and then execute a *'docker -i -t <container-id> /bin/bash'* command for opening each terminals)

### The Producer
Now, in the Producer Terminal, a **TOPIC** (let's named *test_topic*) must be created linked to the Zookeeper process
```
$> kafka-topics --create --zookeeper zookeeper:2181 --partitions 1 --replication-factor 1 --topic testtopic
```
Then, start the process that will publish datastream to the Kafka Broker from the standard input (keybaord) we are going to use for testing
```
$> kafka-console-producer --broker-list localhost:9092 --topic testtopic
```
Also, the process can be injected with data comming from an external process, let's simulate with a loop
```
$> for x in {1..100}; do echo $x; done | /bin/kafka-console-producer --broker-list localhost:9092 --topic testtopic 
```

### The Consumer
Now, in the Consumer Terminal, the Consumer process must be created linked to the Kafka Broker (let's set a timeout also for testing)
```
$> /bin/kafka-console-consumer --bootstrap-server localhost:9092 --from-beginning --topic testtopic --timeout-ms 10000
```
Now, if everything is setup properly, all text that is typed in the Producer Terminal will appear in the Consumer Terminal and, if you have used the loop, all numbers will appear in the screen.

Enjoy it!
