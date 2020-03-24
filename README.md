# playerbio

*Table of contents*

<!--ts-->
  * [Overview](#overview)
  * [Docker](#docker)
    * [Build](#build)
    * [Run](#run)
    * [Docker Compose](#docker-compose)
 * [GitOps](#gitops)
    * [Prerequisites](#prerequisites)
    * [Helm](#helm)
    * [Flux](#flux)
    * [Sealed Secrets](#sealed-secrets)
  * [Monitoring](#monitoring)

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

## Prerequisites

### Helm

This installation/repo assumes an already running k8s cluster (can also be minikube, microk8s, etc)

* Helm should be installed (if via microk8s can use snap). Else see [helm install](https://helm.sh/docs/intro/install/)

### Flux

Install flux repository, crds and namespace:
```sh
$ helm repo add fluxcd https://charts.fluxcd.io && kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml && kubectl create ns flux
```

Configure Flux for the cluster for this repository:
```sh
helm upgrade -i flux fluxcd/flux \
  --set git.url="git@github.com:nuriel77/playerbio.git" \
  --set git.label="k8s-sync" \
  --set git.branch="master" \
  --set git.pollInterval="10s" \
  --set registry.automationInterval="10m" \
  --set registry.rps=50 \
  --set registry.burst=10 \
  --set syncGarbageCollection.enabled="true" \
  --set syncGarbageCollection.dry="false" \
  --set workers=2 \
  --namespace flux
```

Install fluxctl, if via snap:
```sh
sudo snap install fluxctl --classic
```

Alternatively, to install from binary (and make sure `/usr/local/bin` is in your `PATH`):
```sh
wget -O /usr/local/bin/fluxctl https://github.com/fluxcd/flux/releases/download/1.18.0/fluxctl_linux_amd64 && chmod +x /usr/local/bin/fluxctl
```

Get the public ssh key of flux:
```sh
fluxctl identity --k8s-fwd-ns flux
```
And add it to the repository as a deploy key.

### Sealed Secrets

Install the binary:
```sh
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.11.0/kubeseal-linux-amd64 -O /usr/local/bin/kubeseal && chmod +x /usr/local/bin/kubeseal
```
The rest is installed via flux automatically 

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

The binding between the helm chart and flux is done in the directory [flux/](flux/).

The following services have been installed via gitops/flux:

* Playerbio
* prometheus-operator
* Playerbio grafana dashboard
* sealed-secrets

Example fluxctl workloads output:

```sh
$ fluxctl list-workloads -a
WORKLOAD                                                              CONTAINER                   IMAGE                                              RELEASE   POLICY
container-registry:deployment/registry                                registry                    cdkbot/registry-amd64:2.6                          ready
flux:deployment/flux                                                  flux                        docker.io/fluxcd/flux:1.18.0                       ready
flux:deployment/flux-memcached                                        memcached                   memcached:1.5.20                                   ready
flux:deployment/helm-operator                                         flux-helm-operator          docker.io/fluxcd/helm-operator:1.0.0-rc9           ready
                                                                      tiller                      gcr.io/kubernetes-helm/tiller:v2.16.1
kube-system:deployment/hostpath-provisioner                           hostpath-provisioner        cdkbot/hostpath-provisioner-amd64:1.0.0            ready
kube-system:deployment/sealed-secrets                                 sealed-secrets              quay.io/bitnami/sealed-secrets-controller:v0.11.0  ready
kube-system:deployment/tiller-deploy                                  tiller                      gcr.io/kubernetes-helm/tiller:v2.16.0              ready
kube-system:helmrelease/sealed-secrets                                chart-image                 quay.io/bitnami/sealed-secrets-controller:v0.11.0  deployed
monitoring:daemonset/prometheus-operator-prometheus-node-exporter     node-exporter               quay.io/prometheus/node-exporter:v0.18.1           ready
monitoring:deployment/prometheus-operator-grafana                     grafana-sc-dashboard        kiwigrid/k8s-sidecar:0.1.99                        ready
                                                                      grafana                     grafana/grafana:6.6.2
                                                                      grafana-sc-datasources      kiwigrid/k8s-sidecar:0.1.99
monitoring:deployment/prometheus-operator-kube-state-metrics          kube-state-metrics          quay.io/coreos/kube-state-metrics:v1.9.4           ready
monitoring:deployment/prometheus-operator-operator                    prometheus-operator         quay.io/coreos/prometheus-operator:v0.37.0         ready
monitoring:helmrelease/prometheus-operator                                                                                                           deployed
monitoring:statefulset/alertmanager-prometheus-operator-alertmanager  alertmanager                quay.io/prometheus/alertmanager:v0.20.0            ready
                                                                      config-reloader             quay.io/coreos/configmap-reload:v0.0.1
monitoring:statefulset/prometheus-prometheus-operator-prometheus      prometheus                  quay.io/prometheus/prometheus:v2.16.0              ready
                                                                      prometheus-config-reloader  quay.io/coreos/prometheus-config-reloader:v0.37.0
                                                                      rules-configmap-reloader    quay.io/coreos/configmap-reload:v0.0.1
playerbio:deployment/playerbio                                        playerbio                   nuriel77/playerbio:v0.1.2                          ready
playerbio:helmrelease/playerbio                                       chart-image                 nuriel77/playerbio:v0.1.2                          deployed  automated
```

### Troubleshooting Flux

Best view the logs to see what is going on:

Watch flux's logs:
```sh
kubectl logs -n flux deploy/flux --tail 100 -f
```

The flux helm operator logs can offer ideas on why something isn't getting updated or deployed:
```sh
kubectl logs -lapp=helm-operator -c flux-helm-operator -n flux  --tail 1000 -f
```

## Sealed Secrets

Secrets have been added to the repository encrypted by Sealed Secrets. As an example see [flux/monitoring/secrets.yaml](flux/monitoring/secrets.yaml).

Secrets get autodeployed as part of flux and subsequently create the secrets on the k8s cluster to be consumed by resources (e.g. grafana's chart).

Example generate encrypted secret:

```sh
kubectl create secret generic grafana-auth \
    --from-literal=admin="someUser" \
    --from-literal=password="verySecret1234" \
    --namespace monitoring \
    --dry-run \
    --output json \
    | kubeseal \
        --controller-name sealed-secrets \
        --format=yaml
```
Redirect the output into a file to commit to a repository.


# Monitoring

As you can see in the repository flux will deploy the prometheus-operator. Player bio has been configured with a [serviceMonitor](flux/monitoring/serviceMonitor.yaml) in order for its `/metrics` path to be scraped by prometheus. The metrics are consumed by the grafana dashboard Player Bio. It is a mix of some of the erlang exposed metrics and kubernetes metrics

