#!/bin/sh
docker build --tag=zk --file ./Zookeeper-Dockerfile.yaml .
docker build --tag=kf --file ./Kafka-Dockerfile.yaml .