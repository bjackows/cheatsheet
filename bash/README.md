### Export variable from JSON string

```
#!/bin/bash
exec 6< <(jq -cn \
    '{"blih": {"blih": true}, "blah": "=false;ls"}')

for a in $(jq 'to_entries[] | (.key | tostring) + "=" + (.value | tostring)' -r <&6)
do
	declare "$a"
done

echo $blah
echo $blih
```

### Register a trap function
```
trap_delete_temp_dir() {
	local dir=${1}
	trap "{ [ ! \"x${dir}\" = \"x\" ] && rm -rf \"${dir}\"; }" EXIT
}
trap_delete_temp_dir "${temp_dir}"
```

### Redirect stdout to a file

https://www.tldp.org/LDP/abs/html/x17974.html

```
exec 6>&1
exec 1>test.log 2>&1

echo toto
echo toto >&2
echo titi >&6

cat < "test.log" >&6
```

### Move file in place

```
sed '' <file 1<>file
```

### Create subcommand and assign filedescriptor

```
#!/bin/bash

exec 6< <(dd if=/dev/zero bs=512 count=100000 asdf)

echo toto
wc -c <&6
echo titi
```

### Xargs, jq and export bash function

```
process() {
	echo "arg1: \"${1}\" arg2: \"${2}\""
}

export -f process

seq 1 10 | \
	jq --arg arg1 "first blih" -rR '[($arg1 | @sh), (. | split(" ")[-1] | @sh)] | @tsv' | \
	xargs -n2 -P4 bash -c "process \"\${@}\"" _

```
