#!/bin/bash

docker-compose up --no-start

for container in zookeeper-1 zookeeper-2 zookeeper-3; do
  docker-compose start $container
done

echo "Sleeping 10s..."
sleep 10

for container in kafka-1 kafka-2 kafka-3; do
  docker-compose start $container
done

echo "Sleeping 10s..."
sleep 10

for container in kafka-connect-1 kafka-connect-2 kafka-connect-3; do
  docker-compose start $container
done

echo "Sleeping 10s..."
sleep 10

docker-compose start

exit 0

