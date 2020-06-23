## Grab the latest tag for prefix

```
#!/bin/bash

set -eufo pipefail

PREFIX=my-branch
SUFFIX=""
IMAGE_NAME=nginx
aws ecr describe-images \
  --repository-name "${IMAGE_NAME}" \
  --query "sort_by(imageDetails,&imagePushedAt)[*].imageTags[?starts_with(@,\`\"${PREFIX:-}\"\`)]|[]|[?ends_with(@,\`\"${SUFFIX:-}\"\`)]|[-1]||\`\`" \
  --output text
```
