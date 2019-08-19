# `docker-waterfall`

Docker image for BungeeCord fork called Waterfall at https://papermc.io

Please refer to the [official documentation for BungeeCord](https://www.spigotmc.org/wiki/bungeecord-configuration-guide/) for information how to use this.

## Build

Build latest version:

```bash
docker build \
    --tag nicholasdille/waterfall \
    .
```

Build with specific version of Waterfall:

```bash
docker build \
    --build-arg WATERFALL_VERSION=1.14.4 \
    --tag nicholasdille/waterfall \
    .
```

Build with specific version of Java:

```bash
docker build \
    --build-arg JAVA_VERSION=10 \
    --tag nicholasdille/waterfall \
    .
```

## Launch

```bash
docker run \
    -d \
    --name bungee \
    --mount type=bind,source=/opt/minecraft/bungee,target=/var/opt/waterfall \
    -p 25565:25565 \
    nicholasdille/waterfall
```

Also see `docker-compose.yml` for integration with [`docker-papermc`](https://github.com/nicholasdille/docker-papermc/).
