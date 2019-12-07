### Inspect containers

- `-n` controls the number of containers to pass to docker
- `-P` controls the number of parallel commands

```
{ docker ps -q | \
  xargs -n8 -P8 bash -c '[ $# -eq 0 ] && exit; docker inspect $@' _
} | jq -n '[inputs] | .[][] | keys'
```

### Remove untagged images

```
docker images -q --filter "dangling=true" | xargs docker rmi
```

### Resource

- https://towardsdatascience.com/slimming-down-your-docker-images-275f0ca9337e
