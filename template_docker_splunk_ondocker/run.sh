#!/bin/bash

docker-compose up --no-start

echo "Starting up Splunk container..."
docker-compose up -d --no-deps splunk

echo "Sleeping 30s..."
sleep 30

docker-compose up -d zookeeper-1
docker-compose up -d zookeeper-2
docker-compose up -d zookeeper-3

echo "Sleeping 10s..."
sleep 10

docker-compose up -d kafka-1
docker-compose up -d kafka-2
docker-compose up -d kafka-3

echo "Sleeping 10s..."
sleep 10

docker-compose up -d  kafka-connect-1

echo "Sleeping 60s..."
sleep 60

docker-compose up -d

exit 0
