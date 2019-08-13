# travis-listener chart

This chart installs [travis-listener](https://github.com/travis-ci/travis-listener) on kubernetes.

The environment variables are set through [trvs-operator](https://github.com/travis-ci/trvs-operator/) which in turn fetches the full config from the super secret keychain.

## Installation

```bash
helm upgrade --install --set trvs.enabled=true,trvs.env=staging-1 .
```
