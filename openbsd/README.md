### Connect serial

```
cu -s 9600 -l /dev/cuaU0
```

### Configure vlan

`/etc/hostname.vlan11`
```
dhcp parent re0 vnetid 11
```

### Deactivate suspend on lid closing

```
sysctl machdep.lidaction=0
```

### Tor chroot

From https://trac.torproject.org/projects/tor/wiki/doc/OpenbsdChrootedTor

```
pkg_add -rv tor
dd if=/dev/zero of=tor_chroot.img bs=1m count=50
vnconfig vnd1 chroot.img
disklabel -E vnd1
  a a
  w
  q
newfs /dev/rvnd1a
mkdir /mnt/tor-chroot
mount /dev/vnd1a /mnt/tor-chroot
ldd "$(which tor)" |
awk '{print $7}' |
tail -n +4 |
xargs -n1 sh -c '
  mkdir -p /mnt/tor-chroot/"$(dirname "$1")"
  cp "$1" "/mnt/tor-chroot/$1"
' _
mkdir /mnt/tor-chroot/sbin
mkdir /mnt/tor-chroot/var/{log, lib, run}
cp "$(which ldconfig)" /mnt/tor/chroot/sbin
chroot /mnt/tor-chroot/ /sbin/ldconfig /usr/local/bin
mkdir -p /mnt/tor-chroot/home/tor/.tor
chown -R _tor:_tor /mnt/tor-chroot/home/tor
chmod -R 0700 /mnt/tor-chroot/home/tor
```

Run tor:

```
chroot -u _tor /mnt/tor-chroot /usr/local/bin/tor -f /home/tor/.torrc > /dev/null 2>&1 &
```

Note that it does not support the `RunAsDaemon` flag as it would exit the chroot.

### Source based routing

```
pass in on $int_if from $int_net route-to {($ext_if $ext_gw)}
```
