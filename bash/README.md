### Export variable from JSON string

```
#!/bin/bash
exec 6< <(jq -cn \
	'{"blih": {"blih": true}, "blah": "=false;ls"}')

for a in $(jq 'to_entries[] | "\(.key | tostring)=\(.value | tostring)"' -r <&6)
do
	declare "${a}"
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

### Change directory where the script lives

```
cd "$( cd "$(dirname "$0")"; pwd -P)"
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

### Escape everything in here-doc

```
cat - << 'EOF'
echo $pwd
EOF
```

### Deploy config files using sudo

```
myconfig() {
cat - << 'EOF'
$blih=blah
EOF
}

sudo -u nobody bash <<< EOF
cat - << 'EE' > ~/.config
$(myconfig)
EE
EOF
```

### Expend variables as arguments

```
blih=(-l -s ";test")

ls "${blih[@]}"
```

### Trap exit

Careful escaping the `$?` variable, I just got bit in the butt twice.

```
set -e
set -o pipefail

exec 6>&1
exec 7>&2
log_file=$(tempfile)
exec > "${log_file}" 2>&1
trap "[ \"\$?\" -eq 0 ] || cat \"${log_file}\" >&7 && rm \"${log_file}\"" EXIT

set -x
```

### Job control

```
#!/bin/bash
set -m # Enable job control in scripts

for container in $(docker ps -q)
do
        docker logs -f "${container}" &
done

# Variant 1

set +e

while true # block on each job until there is an interupt
do
	fg %-
	[ $? -eq 130 ] && break
	jobs %- || break
done

while true
do
        kill %- || break # Kill jobs one by one
        sleep 0.5 # Sleep a little bit because signals are async
done
set -e

## Variant 2
while true
do
        fg %- # Give control to the first job in the list
	jobs %- || break # check if there a next job
done
```

### Extract pattern from tar archive

Works with glob patterns.

```
tar -xf cbz.tar --wildcards --no-anchored '*.php'
```

### Multi thread line count

```
find <dir> -type f | xargs -n1 -P 32 bash -c 'wc -l $1' _ | awk '{sum+=$1}END{print sum}
```

### Find if ip is in CIDRs

```
grepcidr "$(curl https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[] | select(.region == "us-east-1") | select (.service == "AMAZON") | .ip_prefix' | sort -n)" <<< "1.195.128.120"
```

```
curl -s https://ip-ranges.amazonaws.com/ip-ranges.json |
jq -r '
	.prefixes[] | select(.region == "us-east-1") |
	select (.service == "AMAZON") | .ip_prefix
' |
sort -n |
xargs -n1 -P10 bash -c '
	for a in $(dig A +short email-smtp.us-east-1.amazonaws.com)
	do grepcidr "${1}" <<< "${a}" && echo $1; done
' _ |
grep /
```
