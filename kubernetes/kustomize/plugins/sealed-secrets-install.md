# Kustomize generator that fetches sealed-secret controller on github


File: `kustomize/sealed-secrets/v0.0.1/install/install`
```
#!/bin/bash
## Requires:
## 	- curl
## 	- yq
##	- kustomize

set -eufo pipefail

VERSION=$(yq r <(echo "${KUSTOMIZE_PLUGIN_CONFIG_STRING}") 'version')
curl -fLs "https://github.com/bitnami-labs/sealed-secrets/releases/download/${VERSION}/controller.yaml"
```

File: `kustomization.yaml`
```
resources:
- some-deployment.yaml
generators:
- install.yaml
```

File: `install.yaml`
```
---
apiVersion: sealed-secrets/v0.0.1
kind: install
metadata:
  name: sealed-secrets
version: v0.12.4
```
