# DevOpsLab
## Set ELK (Elasticsearch, Logstash, FileBeat and Kibana) in one single-node installation

The purpose of this lab is shown the basics of an ELK stack, how the modules are interconnected 
and how the data flows through the elements.

This example of ELK implementation **must not** be used in a production environment as it is not securely configured.

Project structure:
```
.
└── docker-compose.yml
└── README.md
```

[_docker-compose.yml_](docker-compose.yml)
```
services:
  elasticsearch:
    image: elasticsearch:7.8.0 (or build directly with plugins)
    ...
  cerebro:
    image: lmenezes/cerebro
    ...
  logstash:
    image: logstash:7.8.0
    ...
  nginx:
    image: nginx:latest #just for testing purposes
    ...
  kibana:
    image: kibana:7.8.0
    ...
  filebeat:   
    image: filebeat:latest
    ...
```

## Deploy with docker-compose

```
$ docker-compose up -d
Creating network "ELK elastic" with driver "bridge"
Pulling elasticsearch...
Pulling logstash...
Pulling kibana...
Creating els ... done
Creating cerebro ... done
Creating logst ... done
Creating kib ... done
Creating nginx ... done
Creating filebeat ... done
```

## Expected result

If everything is OK, you must see six containers running and the port mapping as displayed below (notice container ID could be different):
```
$ docker ps
CONTAINER ID  IMAGE                 COMMAND                  CREATED         STATUS                 PORTS                                               NAMES
45e9b302d0f0  elasticsearch:7.8.0   "/tini -- /usr/local…"   12 seconds ago  Up 2 seconds (healthy) 0.0.0.0:47321->9200/tcp, 0.0.0.0:49156->9300/tcp    els
a4c4f0d0f048  cerebro:latest        "/usr/local/bin/dock…"   12 seconds ago  Up 2 seconds           0.0.0.0:9000->9000/tcp                              cerebro
164f0553ed54  logstash:7.8.0        "/usr/local/bin/dock…"   13 seconds ago  Up 1 seconds           0.0.0.0:5000->5000/tcp, 0.0.0.0:5044->5044/tcp, 0.0.0.0:9600->9600/tcp, 0.0.0.0:5000->5000/udp   logst
fd3f0b35b448  kibana:7.8.0          "/usr/local/bin/dumb…"   14 seconds ago  Up 2 seconds           0.0.0.0:5601->5601/tcp                               kib
e2f3bacd4f46  filebeat:latest        "/usr/local/bin/dock…"  12 seconds ago  Up 1 seconds           0.0.0.0:                                             filebeat
a4f767a4b3c2  nginx:latest          "/docker-entypoint…"     12 seconds ago  Up 1 seconds           0.0.0.0:4000->4000/tcp                               nginx
$ 
```

Then, you can verify each application using the below links in your local web browser:

* Elasticsearch: [`http://localhost:9200`](http://localhost:9200)
* Cerebro: [`http://localhost:9000`](http://localhost:9000)
* Logstash: [`http://localhost:9600`](http://localhost:9600)
* Kibana: [`http://localhost:5601`](http://localhost:5601)

Stop and remove the containers (add -v if data must be deleted)
```
$ docker-compose down
```
---
---
## F.A.Q.

### CEREBRO: How connect to ElasticSearch from the Cerebro screen?
You must type `http://elasticsearch:9200` (this is the hostname that is provided in the docker-compose for the service "elasticsearch". 
Do not use localhost (as you are login from inside the docker container)

### FILEBEAT: How to change the output destination in the filebeat module from logstash to elasticsearch.
To change the output destination, edit the "filebeat.yml" file in the "filebeat/conf" directory.
Then, uncomment the lines that describe the output related to elasticsearch.
And ensure the ones related to logstash are commented, as only one output destination is allowed.

### FILEBEAT: How to extract the log information from Nginx to Filebeat
    1- Connect to the FileBeat container opening a console.
```
docker exec -it filebeat /bin/bash
```
    2- When connected, execute the command to enable the nginx configuration inside the Filebeat container. If the reply is that you are not authorised, then reconnect again to the container adding the "-u root" modifier.
```
./filebeat –E "filebeat.config.modules.path=./modules.d/*.yml" modules enable nginx
```
    3- Then, Filebeat is ready to load the standard pre-defined dashboards to kibana (if required)
```
./filebeat setup
```
