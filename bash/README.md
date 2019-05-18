### Export variable from JSON string

```
jq -cn \
    '{"blih": {"blih": true}, "blah": false}' | \
  bash -c \
    'declare -a "x=($(jq -r ".[] | tostring | @sh"))"; echo "${x[blih]}"'
```
