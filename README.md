# playerbio

*Table of contents*

<!--ts-->
   * [Overview](#overview)
   * [Docker](#docker)
     * [Build](#build)
     * [Run](#run)
     * [Docker Compose](#docker-compose)
<!--te-->

# Overview

* Player Bio Source Code can be found in [src](src/)

# Docker

## Build

Enter the directory `src/` and run:

```sh
docker build -t playerbio .
```

By default the `prod` environment will be built. This is currently the only supported option, as specified in [src/mix.exs](src/mix.exs).

If other environments are available forr use (e.g. `dev` or `test`) you can reference the required one to the docker build command via `--build-arg TARGET_ENV=dev` option.

## Run

Example running on the command line:

```sh
docker run -p 8080:8080 -d playerbio:latest
```

## Docker Compose

Docker compose can come in handy for development purposes.

Example build and start up the application:
```sh
docker-compose up
```
Note: add `-d` to run in background.

Stop:
```sh
docker-compose down
```
