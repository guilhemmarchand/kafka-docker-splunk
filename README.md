# kafka-docker-splunk

Copyright 2018-2020 Guilhem Marchand

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

This repository contains docker-compose templates that will create ouf of the box a full Kafka Confluent OSS environment in Docker.

Its purpose is first of all to qualify, test and demonstrate the monitoring of a full Kafka/Confluent environment with Splunk.

**The following diagram represents the metrics data collection:**

![screen1](./img/overview_diagram.png)

**Two docker-compose.yml templates are provided in the following directories:**

[./template_docker_splunk_ondocker](./template_docker_splunk_ondocker/)

[./template_docker_splunk_localhost](./template_docker_splunk_localhost/)

The first template suffixed by "_ondocker" will run a Splunk standalone instance in Docker, while the second will attempt to send metrics to your local Splunk instance. (using the dockerhost container to communicate with your local guest machine)

In the case of the template running Splunk on Docker, the setup of Splunk (index definition, HEC token creation, installation of Kafka Smart Monitoring) is entirely automatic.

In both cases, the target for HEC telegraf metrics forwarding (your Splunk server running the HTTP Event Collector) and the token are variables loaded as environment variables in the Telegraf containers:

```
      SPLUNK_HEC_URL: "https://dockerhost:8088"
      SPLUNK_HEC_TOKEN: "205d43f1-2a31-4e60-a8b3-327eda49944a"
```

Shall you want to send the metrics to a third party destination and/or using a different token value, modify these values in the docker-compose.yml file.

For the purpose of the template, we hande as well the forwarding of the container logs running our Kafka components to Splunk using the Docker Splunk logging driver, such that both metrics and logs are provided to Splunk in a automated and easy way.

If you use the localhost template, you need to handle the HEC token definition, such as defined in the YAML file:

```
      splunk-token: "11113ee7-919e-4dc3-bde6-da10a2ac6709"
      splunk-url: "https://localhost:8088"

```

Consult the directories in [./splunk](./splunk/) to consult configuration files and examples.

If you use the ondocker template to run the Splunk instance in Docker, you do not need to do anything.

## Included containers

- Zookeeper cluster (3 nodes)
- Kafka broker cluster (3 nodes)
- Kafka connect cluster (1 node, can be extended up to 3 or more with additional config)
- Confluent schema-registry
- Confluent kafka-rest
- Confluent ksql-server
- Kafka Xinfra SLA monitor container
- Telegraf container polling and sending to your Splunk metric store
- Yahoo Kafka Manager (port exposed to localhost:9000)
- Confluent Interceptor console collector
- Kafka Burrow Consumer lag Monitoring (port exposed to localhost:9001, login: admin, password: ch@ngeM3)

In addition, these templates will run a few containers that will create a Kafka stream from Confluent example repositories, to create a consumer we can monitor and generate some activities in Kafka.

### Requirements

**To be able to use these templates, you need:**

- docker
- docker-compose

**Docker-CE is recommanded:**

- https://docs.docker.com/engine/install/ubuntu/

**To install docker-compose:**

- https://docs.docker.com/compose/install/

**Several ports are exposed to the localhost, and need to be available on the machine:**

- 12181 / 22181 / 32181 (Zookeeper)
- 19092 / 29092 / 39092 (Kafka Brokers)
- 18082 / 28082 / 38082 (Kafka Connect if up to 3 nodes)
- 18081 (schema-registry)
- 18088 (ksql-server)
- 18089 (kafka-rest)
- 9000 (kafka-manager)
- 9002 (Burrow)
- 7070 (kafka stream sample app)
- 8000 / 8089 / 8088 / 9997 (Splunk, only if using _ondocker template)

This can be resource intensive with if you run heavy benchmarks.

### Using the templates

**Start by cloning the repository:**

```
git clone git@github.com:guilhemmarchand/kafka-docker-splunk.git
```

**Then to start a template:**

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

Verify metrics ingestion in Splunk:

```
| mcatalog values(metric_name) as metric_name, values(_dims) where index=telegraf_kafka

```

Or using the msearch command:

```
| msearch index=telegraf_kafka filter="metric_name="*""
```

#### Kafka Smart Monitoring application

If you use a local or remote Splunk instance, download and install the application from Splunk Base:

https://splunkbase.splunk.com/app/4268/

If you use Splunk on Docker, the app is already installed for you.

![telegraf-kafka.png](./img/telegraf-kafka.png)

#### Transfer files between host and the Splunk container

If you are using the _ondocker template, you can easily make files available to the container:

You can use the splunk/container_share directory to share files with the splunk docker container (in /opt/splunk/container_share) for ease.

This is specially useful if you want to run ITSI.

#### ITSI module for Kafka Smart Monitoring

If you deployed ITSI, or if you are running ITSI on the Splunk target instance, download and install the Kafka module:

https://splunkbase.splunk.com/app/4261/

Restart Splunk after the installation, you can start creating the entities using the builtin entities discovery, and create services with the builtin service templaces.

![service_analyser.png](./img/service_analyser.png)

#### To destroy the environment:

Finally, you can totally destroy the environment:

```
./destroy.sh
```

#### What about event logging?

This repository does not manage the indexing of event logs from the different components, the aspects are entirely taken in charge by the Kafka Smart Monitoring application, and the ITSI Module for Kafka Smart Monitoring.

See for more information:

https://splunk-guide-for-kafka-monitoring.readthedocs.io

https://github.com/guilhemmarchand/splunk-guide-for-kafka-monitoring/

#### Traditional dedicated, Kubernetes, real-world configuration and Production ready

The purpose of these templates is to demonstrate and/or build a easy quick lab in a minute.

Real World instructions and templates for a Production ready deployment, be in Kubernetes or traditional dedicated servers, are covered in the following repository:

https://github.com/guilhemmarchand/splunk-guide-for-kafka-monitoring/
