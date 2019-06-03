# kubernetes-config

Travis services running on Kubernetes!

This repo contains configuration for all of the Kubernetes services that we run for Travis CI. Currently, we're only using this for our macOS-based infrastructure running on MacStadium.

This repo does not provision the actual Kubernetes cluster that the services run on. For that, see the [terraform-config](https://github.com/travis-ci/terraform-config) repo.

## Related Repos

* [travis-ci/terraform-config](https://github.com/travis-ci/terraform-config)
* [travis-ci/trvs-operator](https://github.com/travis-ci/trvs-operator)
* [travis-ci/worker-operator](https://github.com/travis-ci/worker-operator)

## Organization

This repository is organized into three important directories:

* `charts`
* `releases`
* `shared`

### Charts

The `charts` directory contains various [Helm](https://helm.sh) charts for the various services we deploy in Kubernetes. Each chart is parameterized so that it can be customized as needed and reused between environments.

If you need to make changes to how a service is deployed _everywhere it is deployed_, that change should go in the chart.

You can create a new chart using the `helm create` command:

``` sh
$ helm create charts/my-new-service
```

### Releases

The `releases` directory has subdirectories for each environment that we deploy to (e.g. `macstadium-staging`). The name should match up to the Terraform graph directory that provisions the cluster. For Google Kubernetes Engine, the naming is more complicated, the name can be found with `kubectl config current-context`.

Inside a particular environment's releases directory are YAML files for the different Helm releases that will be deployed to the environment. Each chart deployed to an environment will have its own release where it can be customized as needed.

For example, to deploy jupiter-brain for travis-ci.org in the MacStadium staging environment, we have the following release resource:

``` yaml
apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: jupiter-brain-org
  namespace: macstadium-staging
spec:
  chart:
    path: charts/jupiter-brain
    git: git@github.com:travis-ci/kubernetes-config.git
    ref: staging
  releaseName: jupiter-brain-org
  values:
    trvs:
      enabled: true
      env: staging-1
    honeycomb:
      dataset: jb-requests-staging
```

A few things to note:

* `metadata.name` should match the filename, and ideally should match `spec.releaseName` too.
* `spec.chart` will usually be this repo, and should always use an SSH URL for Git. The `ref` can be omitted to default to master in production.
* `spec.values` can and should be used to override the configuration of the chart for the particular release.
* `spec.releaseName` should match the name of the chart, but may also include differentiators when the same chart is being deployed multiple times in the same namespace.

## Set-up

Deploying releases is done automatically in the cluster using [Flux](https://github.com/weaveworks/flux). No setup is needed on your local machine to do deploys.

However, you may want to inspect the state of the cluster from your machine. You should set up a `kubectl` context to point at the right cluster and namespace.

You can configure such a context automatically from the `terraform-config` repo by running `make context` from the appropriate graph directory. This should only need to be done once per development machine, unless the cluster master has to be rebuilt for some reason.

## Usage

Deploying changes is as easy as `git push`ing to master!

Existing environments should already have Flux set up (see `shared/install-flux.sh` for doing so in a new cluster). Flux as we use it comes in two pieces: `flux` and `flux-helm-operator`.

### flux

`flux` on its own just watches a Git repository, watches it for changes, and applies them to the cluster. In our clusters, `flux` is configured to only watch the `releases/<env>/` directory for the corresponding environment. This means it will automatically update the `HelmRelease` resources that define which Helm charts should be deployed in the cluster.

### flux-helm-operator

The `flux-helm-operator` does the rest of the work. It watches for changes in the `HelmRelease` resources that are defined in the cluster and performs Helm upgrades of the corresponding charts as needed. It also watches for changes in the chart contents themselves.

Together, these two components ensure that what is in Git always matches what is running in the Kubernetes.
