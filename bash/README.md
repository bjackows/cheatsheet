### Export variable from JSON string

```
jq -cn \
    '{"blih": {"blih": true}, "blah": false}' | \
  bash -c \
    'declare -a "x=($(jq -r ".[] | tostring | @sh"))"; echo "${x[blih]}"'
```

### Register a trap function
```
trap_delete_temp_dir() {
	local dir=${1}
	trap "{ [ ! \"x${dir}\" = \"x\" ] && rm -rf \"${dir}\"; }" EXIT
}
trap_delete_temp_dir "${temp_dir}"
```
