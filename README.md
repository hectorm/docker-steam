# Steam on Docker

A Docker image for [Steam](https://steampowered.com) based on [Xubuntu on Docker](https://github.com/hectorm/docker-xubuntu).

## Start an instance

### Docker CLI

```sh
docker run \
  --name steam \
  --detach \
  --shm-size 2g \
  --security-opt label=type:spc_t \
  --security-opt seccomp=unconfined \
  --publish 3322:3322/tcp \
  --publish 3389:3389/tcp \
  --publish 4380:4380/udp \
  --publish 27036:27036/tcp \
  --publish 27037:27037/tcp \
  --publish 27000-27100:27000-27100/udp \
  --device /dev/dri:/dev/dri \
  docker.io/hectorm/steam:latest
```

### Docker Compose

```yaml
version: '3.9'
services:
  steam:
    image: 'docker.io/hectorm/steam:latest'
    shm_size: '2gb'
    security_opt:
      - 'label=type:spc_t'
      - 'seccomp=unconfined'
    ports:
      - '3322:3322/tcp'
      - '3389:3389/tcp'
      - '4380:4380/udp'
      - '27036:27036/tcp'
      - '27037:27037/tcp'
      - '27000-27100:27000-27100/udp'
    devices:
      - '/dev/dri:/dev/dri'
```

> You will be able to connect to the container via SSH through 3322/tcp port and RDP through 3389/tcp port.

> **Important:** some software (like Firefox) need the shared memory to be increased, if you
encounter any problem related to this you may use the `--shm-size` option.

## Environment variables

* `UNPRIVILEGED_USER_UID`: unprivileged user UID (`1000` by default).
* `UNPRIVILEGED_USER_GID`: unprivileged user GID (`1000` by default).
* `UNPRIVILEGED_USER_NAME`: unprivileged user name (`user` by default).
* `UNPRIVILEGED_USER_PASSWORD`: unprivileged user password (`password` by default).
* `UNPRIVILEGED_USER_GROUPS`: comma-separated list of additional GIDs for the unprivileged user (none by default).
* `UNPRIVILEGED_USER_SHELL`: unprivileged user shell (`/bin/bash` by default).
* `SERVICE_XRDP_BOOTSTRAP_ENABLED`: enable xrdp bootstrap service, initialises user session on startup (`false` by default).
* `SERVICE_XORG_HEADLESS_ENABLED`: enable headless X server service (`false` by default).

## License

See the [license](LICENSE.md) file.
