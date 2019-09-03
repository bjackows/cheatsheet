### Merge xresources to X11

```
xrdb -merge ~/.Xresources
```


### Links:

- https://unix4lyfe.org/xterm/

### IP Source routing

```
ip route flush 11 #interface A
ip route add table 11 to 192.168.0.0/24 dev eth1
ip route add table 11 to default via 192.168.150.1 dev eth1

ip rule add from 192.168.0.0/24 table 11 priority 11 #net 1
```
