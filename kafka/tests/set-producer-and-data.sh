#!/bin/bash
for x in {1..100}; do echo $x; done | kafka-console-producer --broker-list localhost:9092 --topic testtopic
