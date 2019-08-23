# travis-vcs chart

This chart installs [travis-vcs](https://github.com/travis-ci/travis-vcs) on kubernetes.

The environment variables are set through [trvs-operator](https://github.com/travis-ci/trvs-operator/) which in turn fetches the full config from the super secret keychain.

## Installing the Chart

To install the chart with the release name `travis-vcs`:

```console
$ helm upgrade --install travis-vcs --namespace default --set trvs.enabled=true,trvs.env=staging-1 .
```

> **Tip**: List all releases using `helm list`

## Configuration

The following table lists the configurable parameters of the `travis-vcs` chart and their default values.

|               Parameter              |                     Description                    |               Default               |
|--------------------------------------|----------------------------------------------------|-------------------------------------|
| `replicaCount`                       | Default replicaCount                               | `1`                                 |
| `image.repository`                   | Set travis-vcs image repository                    | `quay:io/travisci/travis-vcs`       |
| `image.tag`                          | Set travis-vcs image tag                           | ``                                  |
| `image.PullPolicy`                   | Set travis-vcs image pull policy                   | `IfNotPresent`                      |
| `imagePullSecrets`                   | Secrets for image pull                             | `[]`                                |
| `nameOverride`                       | Set different name then chart name                 | `""`                                |
| `fullnameOverride:                   | Set different full name then chart name            | `""`                                |
| `trvs.enable`                        | Enable pull secrets with trvs                      | `false`                             |
| `trvs.app`                           | Set trvs app name                                  | `travis-vcs`                        |
| `trvs.env`                           | Set trvs environment                               | `""`                                |
| `trvs.pro`                           | Enable pro keychain                                | `false`                             |
| `service.type`                       | Service type                                       | `ClusterIP`                         |
| `service.port`                       | Service port                                       | `3000`                              |
| `ingress.enabled`                    | Enable ingress                                     | `false`                             |
| `ingress.annotations`                | Set annotations for ingress                        | `{}`                                |
| `ingress.hosts`                      | Set list of hosts                                  | ``                                  |
| `ingress.hosts.host`                 | Set host                                           | `chart-example.local`               |
| `ingress.hosts.paths`                | Set paths for host                                 | `[]`                                |
| `ingress.tls`                        | Setup tls for ingress                              | `[]`                                |    

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install/upgrade`.

Alternatively, a YAML file that specifies the values for the configurable parameters can be provided while installing the chart.
For example:

```console
$ helm upgrade --install travis-vcs --namespace default -f values.yaml .
```
> **Tip**: You can use the default [values.yaml](values.yaml)

## Uninstalling the Chart

To uninstall/delete the `travis-vcs` deployment:

```console
$ helm delete --purge travis-vcs
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
