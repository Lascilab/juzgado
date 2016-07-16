# Juzgado
Simple code judge system using docker, ruby and rabbitmq. Posgresql for databe backend.

# Use Case

Imagine that you are a teacher evaluating your students programming class assigments (Perhaps their exams), you know that it can be a little risky compile and run some of them because some can be malicious software so you may call us to solve the problem. With 'Juzgado', all the code is downloaded into a container and later transfere to another with some constrains like memory, cpu, devices, filesystems and of course without internet connection, then compile and evaluated as usual.

It can be use with docker compose, docker swarm and docker machine.

# Architecture

A load balancer distribute all the requests between Ruby on rails servers. If a Student send they solution link, the servers send a message in a pub/sub queue to some workers using ruby...

![Cluster](https://raw.githubusercontent.com/Lascilab/juzgado/master/Juzgado.png)

# Usage

Install Docker Engine and Docker Compose.


```
$> docker-compose up -d
```

