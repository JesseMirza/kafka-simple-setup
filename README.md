# Simple Kafka Cluster 

This is a very simple Kafka setup for my own local development purposes. There might be some settings which are not logical but required for my own purposes. For example, you do not need network aliases but I added for my own requirements.

It creates one *Zookeeper* and two *Kafka* brokers.

It uses SSL for authentication. Required certificates are already generated; but if they are expired or if you need to re-generate go to certs folder and execute create-with-docker.sh (or ps1 on windows). It will update the certificates in certs/certificates. You can use client or admin keystores (and truststores for trusting to brokers) for testing. Please note that admin is a superuser. All passwords for all keystore/truststore are test1234.

Please map *kafka1* and *kafka2* to your *localhost* in your */etc/hosts/* or *C:\Windows\System32\Drivers\etc\hosts* so that you can connect from your localhost to brokers easily.

You should run `build.sh` or `build.ps1` and then do `docker-compose up`.
Run a shell (or you can access from your local machine as well) inside on of the running containers. For example for Zookeeper instance:  `docker exec -i -t zookeeper bash`. This will log you into Zookeeper instance.

Cat the example commands to work with SSL authentication: `cat /app/example-commands.txt`
