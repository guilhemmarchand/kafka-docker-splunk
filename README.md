# kafka-docker-splunk

## purpose:

This repository contains simple configuration templates that will run a full Kafka environment in Docker.

Two templates are provides:

### template_docker_splunk_ondocker

This template will run:

- Zookeeper cluster (3 nodes)
- Kafka broker cluster (3 nodes)
- Kafka connect cluster (3 nodes)
- Splunk standalone instance pre-configured (login: admin / password: ch@ngeM3) with port redirected to your localhost
- Kafka LinkedIn monitor container
- A Telegraf container collecting metrics from Zookeeper and Kafka brokers
- A Telegraf container collecting metrics from LinkedIn Kafka monitor

### template_docker_splunk_localhost

This template will the same infrastructure in docker except the Splunk instance, Telegraf containers will forwarder data to your Splunk localhost:

- Zookeeper cluster (3 nodes)
- Kafka broker cluster (3 nodes)
- Kafka connect cluster (3 nodes)
- Splunk standalone instance pre-configured (login: admin / password: ch@ngeM3)
- Kafka LinkedIn monitor container
- A Telegraf container collecting metrics from Zookeeper and Kafka brokers
- A Telegraf container collecting metrics from LinkedIn Kafka monitor

Notes:

Telegraf will attempt to forward metrics to your localhost on port 8088, a HEC token and index shall be created, configuration are available in splunk/TA-telegraf-kafka directory.

### Requirements

To be able to use these templates, you need:

- docker
- docker-compose

### Using the templates

Start by cloning the repository:

```
git clone git@github.com:guilhemmarchand/kafka-docker-splunk.git
```

Then to start a template:

```
cd template_docker_splunk_ondocker
./run.sh
```

Docker will download any image required, and the start the full environment.

Splunk requires around 30 seconds to start, you can verify the instance state:

```
docker-compose logs splunk
```

Once Splunk has been started, you can access to Splunk Web:

http://localhost:8000

- login: admin
- password: ch@ngeM3

To destroy the environment:

```
./destroy.sh
```

Verify metrics ingestion in Splunk:

```
| mcatalog values(metric_name) as metric_name, values(_dims) where index=telegraf_kafka
```

Recommendation: Install the Metrics Workspace application in Splunk:

https://splunkbase.splunk.com/app/4192/

