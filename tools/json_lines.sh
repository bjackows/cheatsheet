#!/bin/bash

### This script will create a json object for each line that it receives in input.

set -x

usage() {
	echo "Usage of ${0}: <server> <port> <type> <array length>" > /dev/stderr; exit 2
}

[ "x${1}" = "x" ] && usage
[ "x${2}" = "x" ] && usage
[ "x${3}" = "x" ] && usage
[ "x${4}" = "x" ] && usage

server=${1}
port=${2}
type=${3}
length=${4}
username=$(whoami)

id=$(openssl rand -hex 12)

[ "x${id}" = "x" ] && echo "Something went wrong with uniq id" 2> /dev/null && exit 2

now() {
	jq -R 'split(" ")[0] | tonumber' < /proc/uptime
}

before=$(now)
created_at=$(date +%s)

{ cat - |
	jq \
		--arg id "${id}" \
		--arg type "${type}" \
		--arg length "${length}" \
		-nR --unbuffered -c \
		'def nwise(stream; $n):
			foreach (stream, nan) as $x ([];
				if length == $n then [$x] else . + [$x] end;
				if (.[-1] | isnan) and length>1 then .[:-1]
				elif length == $n then .
				else empty
				end);
			(nwise((inputs | {"line_offset": input_line_number, "line": .}); ($length | tonumber)) | map(select((. | isnan) == false))) as $array |
			if ($array | length) == 0 then empty else
				{"max_offset": input_line_number, "type": $type, "status": "running", "id": $id, "lines": $array, length: ($array | length)} end' && \
	jq \
		-n \
		-c \
		--unbuffered \
		--arg id "${id}" \
		--arg type "${type}" \
		--arg before "${before}" \
		--arg now "$(now)" \
		--arg username "${username}" \
		--arg created_at "${created_at}" \
		'{"username": $username, "created_at": ($created_at | tonumber | todate), "type": $type, "id": $id, "status": "stopped", "took": (($now | tonumber) - ($before | tonumber))}';
	touch "/tmp/${id}";
} | while [ ! -f "/tmp/${id}" ]; do nc -v "${server}" "${port}"; sleep 0.5 ; done;

rm "/tmp/${id}" || true
