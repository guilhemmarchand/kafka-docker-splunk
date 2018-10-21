# kafka-docker-splunk

Copyright 2018 Guilhem Marchand

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## purpose:

This repository contains simple configuration templates that will run a full Kafka environment in Docker.

![screen1](./docs/img/draw.io/docker_template.png)

Two templates are provided:

### template_docker_splunk_ondocker

This template will run:

- Zookeeper cluster (3 nodes)
- Kafka broker cluster (3 nodes)
- Kafka connect cluster (3 nodes)
- Splunk standalone instance pre-configured (login: admin / password: ch@ngeM3) with port redirected to your localhost
- Kafka LinkedIn monitor container
- A Telegraf container collecting metrics from Zookeeper and Kafka brokers
- A Telegraf container collecting metrics from Kafka Connect
- A Telegraf container collecting metrics from LinkedIn Kafka monitor

### template_docker_splunk_localhost

This template will the same infrastructure in docker except the Splunk instance, Telegraf containers will forwarder data to your Splunk localhost:

- Zookeeper cluster (3 nodes)
- Kafka broker cluster (3 nodes)
- Kafka connect cluster (3 nodes)
- Kafka LinkedIn monitor container
- A Telegraf container collecting metrics from Zookeeper and Kafka brokers
- A Telegraf container collecting metrics from Kafka Connect
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

![screen1](./img/screen001.png)
