## Grab the latest tag for prefix

```
#!/bin/bash

set -eufo pipefail

DEFAULT_PREFIX=my-branch
IMAGE_NAME=nginx
aws ecr describe-images \
  --repository-name "${IMAGE_NAME}" \
  --query "sort_by(imageDetails,&imagePushedAt)[*].imageTags[?starts_with(@,\`${DEFAULT_PREFIX:-}\`)]|[-1][0]||\`\`" \
  --output text |
rev |
cut -d - -f 2- |
rev
```
