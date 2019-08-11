### Connect serial

```
cu -s 9600 -l /dev/cuaU0
```

### Configure vlan

`/etc/hostname.vlan11`
```
dhcp parent re0 vnetid 11
```
