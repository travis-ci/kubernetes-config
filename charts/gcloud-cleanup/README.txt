# gcloud-cleanup chart

This chart installs [gcloud-cleanup](https://github.com/travis-ci/gcloud-cleanup) on kubernetes. The environment variables are set through [trvs-operator](https://github.com/travis-ci/trvs-operator/) which in turn gets it from the super secret keychain.

## Installation

```bash
helm upgrade --install --set trvs.enabled=true,trvs.env=staging-1 .
```
