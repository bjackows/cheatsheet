#!/bin/bash

set -e
set -o pipefail

exec 6>&1
temp=$(tempfile)
exec > "${temp}"


trap "[ \$? -eq 0 ] && cat \"${temp}\" > /etc/hosts; rm \"${temp}\"" EXIT

{
        echo \
"127.0.0.1      localhost.localdomain   localhost
::1             localhost6.localdomain6 localhost6

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts

## Added from docker"

docker ps -q -f label=ansible | \
        xargs -r -P8 -L8 docker inspect | \
        jq -nc -r '
                        [inputs][][] |
                        .NetworkSettings.Networks.bridge.IPAddress as $ip |
                        ["\($ip) \(.Config.Hostname)", "\($ip) \(.Config.Labels.group)"] |
                        join("\n")
                '
}
