## DevOpsLab
### Set Jupyter in one-single node installation with some runbooks for testing

The purpose of this lab is to show how to use Jupyter Notebooks to create 
and execute Operational RunBooks in DevOps.
In a real production environment the docker will not require postgress inside.

Project structure:
```
.
├── docker-compose.yml
├── jupyter
│   └── Dockerfile
├── data
└── runbooks
```

[_docker-compose.yaml_](docker-compose.yaml)
```
services:
  postgres-db:
    image: postgres
    ...
  jupyter:
    build: 
      context: ./jupyter
    ports:
      - 8888:8888
      ...
```
This compose file will create a PostGres DB (`postgres-db`) and a Jupyter (`jupyter`) instances.
IMPORTANT NOTICE: Port 8888 on the host MUST NOT already in use.
Information to analise will be stored in "data" directory and the runbooks will be saved in "runbooks" directory.

## Deploy with docker-compose

```
$ docker-compose build
Creating docker image "jupyter" ... done
...
$ docker-compose up -d
...
Creating volume "runbooks" with default driver
...
Creating postgres-db ... done
Creating jupyter ... done
Attaching to postgres-db, jupyter
```

## Expected result

Listing containers must show two containers running and the port mapping as below:
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
45e9b302d0f0        jupyter            "jupyter -f ..."         11 seconds ago       Up 10 seconds       0.0.0.0:8888->8888/tcp   jupyter
164f0553ed54        postgres-db        "/run.sh"                10 seconds ago       Up 9 seconds        0.0.0.0:0->0/tcp         postgres-db
```

Then you can launch each application using the below links in your local web browser:

* Jupyter: [`http://localhost:8888`](http://localhost:8888)

After started, some example runbooks can be accesed from inside the Jupyter desktop in the "runbook" folder of this repository

Stop and remove the containers. Use `-v` to remove the volumes if looking to erase all data.
```
$ docker-compose down -v
```
