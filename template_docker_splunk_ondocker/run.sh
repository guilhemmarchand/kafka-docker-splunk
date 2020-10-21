#!/bin/bash

docker-compose up --no-start

for container in zookeeper-1 zookeeper-2 zookeeper-3; do
  docker-compose up -d $container
done

echo "Sleeping 10s..."
sleep 10

for container in kafka-1 kafka-2 kafka-3; do
  docker-compose up -d $container
done

echo "Sleeping 10s..."
sleep 10

for container in kafka-connect-1; do
  docker-compose up -d $container
  echo "Sleeping 5s..."
  sleep 5
done

echo "Sleeping 60s..."
sleep 60

docker-compose up -d

exit 0
