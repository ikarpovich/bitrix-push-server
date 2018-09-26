# What is Bitrix Push Server

Push Server is a NodeJS app built by [Bitrix Inc.](https://www.bitrix24.com) to handle realtime communications within Bitrix 
platform. It is usually installed as part of [Bitrix Environment](https://www.bitrix24.com/self-hosted/installation.php).

# Use case for this Docker image

If you'd like to run Bitrix24 in Docker on your own making realtime comms, i.e. chat and video calls to work is tricky.
This image contains Bitrix Push Server from original Bitrix Environment package and can easily be placed into your existing project. 
The image is tested to work with *Docker Compose* and *Docker Swarm*.

# How to use the image

## ... on its own

You have to start [Redis](https://hub.docker.com/_/redis/) first.

```console
$ docker run --name bitrix-push-server --link redis:redis -d ikarpovich/bitrix-push-server
```

## ... in [`Docker Swarm`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or via [`Docker Compose`](https://github.com/docker/compose)

The example below shows traefik installed in front of the cluster

```yaml
version: '3'

services:

  push-server-sub:
    image: bitrix-push-server
    links:
      - redis
    networks:
      - default
      - traefik-net
    environment:
      - REDIS_HOST=redis
      - LISTEN_HOSTNAME=0.0.0.0
      - LISTEN_PORT=80
      - SECURITY_KEY=testtesttest
      - MODE=sub
    labels:
      - traefik.port=80
      - traefik.protocol=http
      - traefik.frontend.rule=Host:bitrix24-sub.test
      - traefik.docker.network=traefik-net
      
  push-server-pub:
    image: bitrix-push-server
    links:
      - redis
    networks:
      - default
    environment:
      - REDIS_HOST=redis
      - LISTEN_HOSTNAME=0.0.0.0
      - LISTEN_PORT=80
      - SECURITY_KEY=testtesttest
      - MODE=pub
      
  redis:
    image: redis
    networks:
      - default      
```

## Setup your Bitrix to support the server:

Message sender path: `http://push-server-pub/bitrix/pub/`
Signature code for server interaction: `testtesttest` (your `SECURITY_KEY`)

Message listener path: `http://bitrix24-sub.test/bitrix/subws/` (https:// ws:// wss://)

# Environment variables

### `LISTEN_HOSTNAME`

Hostname to bind daemon to, `0.0.0.0` by default

### `LISTEN_PORT`

Port to bind daemon to, `80` by default

### `REDIS_HOST`

Redis hostname, `redis` by default

### `REDIS_PORT`

Redis port, `6379` by default

### `SECURITY_KEY`

Security key, has to match one in *Push & Pull* system module settings

### `MODE`

Mode should be either `pub` or `sub`. You have to launch two containers with each mode to work.

# License

License for this image is MIT.
Bitrix and Bitrix Environment, Bitri Push Server are products licensed by Bitrix Inc. under their licenses terms.