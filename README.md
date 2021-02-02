# DevOpsLab
## Examples for the DevOps Course

Please, follow the link to the appropiate resources

- These examples are provided for the use in the DevOps Course Lab to deploy in a single local installation . 
- They are not recommended to be used directly in production environments specially regarding security issues.

### DevOps Monitoring Tools
- [`Prometheus-Grafana`](https://github.com/JuanLuisGozaloFdez/DevOpsLab/tree/main/prometheus-grafana) - Sample Prometheus and Grafana applications.
- COMMING SOON - Sample ElasticSearch-Logstash-Kibana stack.
- COMING SOON- Sample Kafka application.

### DevOps RunBooks Tools
- COMING SOON- Sample Jupyter Notebook application.
- COMING SOON- Sample JupyterHUB Notebooks application.
- COMING SOON- Jupyter RunBooks examples

### Prerequisites

- Docker and Docker Compose must be installed in your local environment or machine:
  - Windows or macOS:
    [Install Docker Desktop](https://www.docker.com/get-started)
  - Linux: [Install Docker](https://www.docker.com/get-started) and then
    [Docker Compose](https://github.com/docker/compose)
- Download some or all of the samples from this repository or clone them.

### Examples

- In each of the directories, a `docker-compose.yaml` exists. That file describes the configuration of the service components. 
- All samples can be executed in a local environment/machine. To do that, you must go into the root directory of each one and executing:

```console
docker-compose up -d
```
To stop and remove all containers of the sample application run:

```console
docker-compose down
```

In each directory, a `README.md` file describes details about the example (structure and instructions) and
what is the expected output.

Enjoy it!!
