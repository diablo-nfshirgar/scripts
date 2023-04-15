# DNS over TLS proxy configuration

This python script configures proxy server in the form of Docker container which will encrypt and forward DNS queries to CloudFlare's DNS server `1.1.1.1` over TLS.

## Pre-requisites

Following are the packages/tools this script assumes already installed on the machine where testing is carried out:
* Docker (v20.10.21)
* Python (v3.10) [This is not an essential to have but maybe useful in case the script needs to be tested and debug locally]

## Setup and Installation of proxy server

In order to configure proxy server, execute the setup script as follows:

```bash
./setup.sh
```

This script will basically perform following:
* Check if `dns_over_tls` proxy container (server) is already present. If it does, it will stop and remove it
* It will build an image using `Dockerfile` located under the same path
* It will then spin up the proxy container using the image and will run it in detached mode using IP `172.17.0.2`

**Please consider following points to be noted:**
* The proxy container creation above assumes that there are no prior containers running in your docker host since this proxy container assumes the first default IP address of docker network which is generally used by the first container during creation
* The port used to query DNS from the container is `950` which is already exposed through image configuration, so we should not expect any additional port exposure in order to test

## Testing the proxy server

Once the container is successfully deployed, you may run DNS query using any of the available query tools. Following are few of the example commands used to query:

```bash
$ dig google.com -t A @172.17.0.2 -p 950
$ kdig -d @172.17.0.2 -p 950 google.com
```

## Answers to the questions

### Imagine this proxy being deployed in an infrastructure. What would be the security concerns you would raise?

There are following concerns aligned with this setup in an infrastructure:
* This setup does not secure the connection between the proxy container and the client which pose a security risk in case if the infrastructure is not secured
* This setup also doesn't also use stengthen security configurations such as strong ciphers to add additional layer of security to the connection

### How would you integrate that solution in a distributed, microservices-oriented and containerized architecture?

This can be useful in a distributed, microservices-oriented architecture for following reasons:
* This setup is already containerized, which means this can be shipped and deployed to any of the decoupled architecture as and when needed
* Since this setup only expose port `950` to query the DNS, this also adds an extra layer and also doesn't require additional configuration at network layer which can ultimately ease the complexity in microservices-oriented architecture
* This setup also doesn't rely on any specific vendor/provider which gives it flexibility to load and deploy in any of the environment

### What other improvements do you think would be interesting to add to the project?

When it comes to improvement, following are the points that can be highlighted:
* This setup is not compatible yet for testing out multiple requests which can be implemented
* Adding a secured cached layer for frequent request may also ome in handy
* At last, the Python code and the configuration written to configure this is not perfect and also has a lot of room for improvement in terms of structure and productivity
