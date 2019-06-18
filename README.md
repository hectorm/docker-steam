# Steam on Docker

A Docker image for [Steam](https://steampowered.com) based on [Xubuntu on Docker](https://github.com/hectorm/docker-xubuntu).

## Start an instance

```sh
docker run --detach \
  --name steam \
  --publish 3389:3389/tcp \
  hectormolinero/steam:latest
```

> You will be able to connect to the container via RDP through 3389/tcp port.

> **Important:** if you use the `--privileged` option the container will be able to use the GPU with
VirtualGL, but this will conflict with the host X server.

> **Important:** some software (like Firefox) need the shared memory to be increased, if you
encounter any problem related to this you may use the `--shm-size` option.

## Environment variables

* `GUEST_USER_PASSWORD`: guest user password (`guest` by default).

## License

See the [license](LICENSE.md) file.
