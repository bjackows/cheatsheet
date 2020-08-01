# Kustomize transformers to automatically encrypt secrets


File: `kustomize/sealed-secrets/v0.0.1/encrypt/encrypt`
```
#!/bin/bash
## Requires:
## 	- yq
##	- jq
##	- kubeseal
##	- kustomize
##	- xargs
## Args:
##	- flags (list of flags to pass to kubeseal

set -eufo pipefail

FLAGS=$(yq -j r <(echo "${KUSTOMIZE_PLUGIN_CONFIG_STRING}") 'flags' | jq 'join(" ")' -r)
export FLAGS

yq -j r - -d '*' |
jq -jrc 'select(.apiVersion == "v1" and .kind == "Secret") | tojson + "\u0000"' |
xargs -0 -n1 -P1 \
	bash -c '
		flags=()
		[ ! -z "${FLAGS}" ] && flags=( ${flags[@]} "${FLAGS[@]}" )
		echo "${1}" |
		yq r --prettyPrint - |
		kubeseal ${flags[@]} |
		jq ".metadata.annotations.\"kustomize.config.k8s.io/id\" = .spec.template.metadata.annotations.\"kustomize.config.k8s.io/id\" | del(.spec.template.metadata.annotations.\"kustomize.config.k8s.io/id\") | tojson" |
		yq r --prettyPrint -
	' _

```

File: `kustomization.yaml`
```
resources:
- some-deployment.yaml
transformers:
- encrypt.yaml
```

File: `encrypt.yaml`
```
---
apiVersion: sealed-secrets/v0.0.1
kind: encrypt
metadata:
  name: linkerd
flags:
  - --cert
  - ../../sealed-secrets.crt.pem
  - -n
  - linkerd
```
