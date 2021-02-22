## DevOpsLab
### Set Jupyter in one-single node installation with some runbooks for testing

The purpose of this lab is to show how to use Jupyter Notebooks to create 
and execute Operational RunBooks in DevOps.

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
  jupyter:
    build: 
      context: ./jupyter
    ports:
      - 8888:8888
      ...
```
This compose file will create a Jupyter (`jupyter`) instances.
IMPORTANT NOTICE: Port 8888 on the host MUST NOT already in use.
Runbooks will be saved in "runbooks" directory.

## Deploy with docker-compose

```
$ docker-compose build
Creating docker image "jupyter" ... done
...
$ docker-compose up -d
...
Creating volume "runbooks" with default driver
Creating jupyter ... done
```

## Expected result

Listing containers must show two containers running and the port mapping as below:
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
45e9b302d0f0        jupyter            "jupyter -f ..."         11 seconds ago       Up 10 seconds       0.0.0.0:8888->8888/tcp   jupyter
```

## How to start using Jupyter
Execute the following command that will access the container to get the token and URL link:
```
docker exec -it jupyter /opt/conda/bin/jupyter notebook list
```
If you are accesing directly with "http://localhost:8888" , then a LOGIN page will be shown asking for the TOKEN that you must obtain before.
After started, some example runbooks can be accesed from inside the Jupyter desktop in the "runbook" folder of this repository (by default)

Stop and remove the containers. Use `-v` to remove the volumes if looking to erase all data.
```
$ docker-compose down -v
```
Note: Remember that when you open a noteboook, you must "Close and Halt" to stop the execution in the background of that notebook.
