# Tiny kustomize plugin for fetching latest ecr image


File: `kustomize/ecr-edit-image/edit-image/edit-image`
```
#!/bin/bash
## Requires:
## 	- aws cli v2
## 	- yq
##	- kustomize

set -eufo pipefail

tmpdir=$(mktemp -d)
trap "rm -rf "${tmpdir}"" EXIT

cd ${tmpdir}
cat - > manifest.yaml
cat - << EOF > kustomization.yaml
resources:
- manifest.yaml
EOF

IMAGE=$(yq r <(echo "${KUSTOMIZE_PLUGIN_CONFIG_STRING}") 'ImageName')
PREFIX=$(yq r <(echo "${KUSTOMIZE_PLUGIN_CONFIG_STRING}") 'Prefix')
SUFFIX=$(yq r <(echo "${KUSTOMIZE_PLUGIN_CONFIG_STRING}") 'Suffix')
REPOSITORY_NAME=$(
	echo "${IMAGE}" |
	cut -d / -f 2-
)

LATEST_TAG=$(aws ecr describe-images \
	--repository-name "${REPOSITORY_NAME}" \
	--query "sort_by(imageDetails,&imagePushedAt)[*].imageTags[?starts_with(@,\`\"${PREFIX:-}\"\`)]|[]|[?ends_with(@,\`\"${SUFFIX:-}\"\`)]|[-1]||\`\`" \
	--output text
)

kustomize edit set image "${IMAGE}:${LATEST_TAG}"
kustomize build .
```

File: `kustomization.yaml`
```
resources:
- some-deployment.yaml
transformers:
- ecr-latest-tag.yaml
```

File: `ecr-latest-tag.yaml`
```
apiVersion: ecr-kustomize-image/v0.0.1
kind: edit-image
metadata:
  name: collection-server
ImageName: <account_id>.dkr.ecr.<region>.amazonaws.com/<repository_name>
Prefix: some-branch
Suffix: ""
```
