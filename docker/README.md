### Inspect containers

- `-L` controls the number of containers to pass to docker
- `-P` controls the number of parallele commands

```
{ docker ps -q | \
  xargs -L 8 -P8 docker inspect
} | jq '.[] | keys'
```
