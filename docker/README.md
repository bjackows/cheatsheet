### Inspect containers

- `-L` controls the number of containers to pass to docker
- `-P` controls the number of parallele commands

```
{ docker ps -q | \
  xargs -r -L8 -P8 docker inspect
} | jq '.[] | keys'
```

### Remove untagged images

```
docker images -q --filter "dangling=true" | xargs docker rmi
```
