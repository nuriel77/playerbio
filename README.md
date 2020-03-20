# playerbio

*Table of contents*

<!--ts-->
   * [Overview](#overview)
   * [Docker](#docker)
     * [Build](#build)
     * [Run](#run)
     * [Docker Compose](#docker-compose)
  * [GitOps](#gitops)
     * [Helm](#helm)
     * [Flux](#flux)
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

# GitOps

## Helm

A chart for helm can be found in [charts/playerbio](charts/playerbio)

If you don't integrate with Flux, a manual installation via Helm is possible, e.g.:
```sh
helm upgrade --install --atomic --wait --timeout=360 --namespace=playerbio playerbio charts/playerbio
```
This command can be used both for installation and upgrade.

Note that the values can be tweaked in `charts/playerbio/values.yaml`, for example the image name or number of **replicas**.

I have set the replicas in `values.yaml` to allow for override via the `base.yaml` from flux, see [Flux](#flux) for more details.

To completely destroy the release run:
```sh
helm delete --purge playerbio
```

## Flux

I have added Flux's public ssh key to the repository `https://github.com/nuriel77/playerbio`. It watches the `master` branch and scans directories for `yaml` files.

The binding between the helm chart and flux is done in the directory [flux/](flux/). The `base.yaml` file references the repository and chart's directory.

