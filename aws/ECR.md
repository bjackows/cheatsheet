## Grab the latest tag for prefix

```
#!/bin/bash

set -eufo pipefail

DEFAULT_PREFIX=ebu_docker
aws ecr describe-images \
  --repository-name backend/collection_server \
  --query "sort_by(imageDetails,&imagePushedAt)[*].imageTags[?starts_with(@,\`${DEFAULT_PREFIX:-}\`)]|[-1][0]||\`\`" \
  --output text |
rev |
cut -d - -f 2- |
rev
```
