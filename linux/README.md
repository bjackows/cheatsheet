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

### Boot usb from grub

From: https://askubuntu.com/questions/947409/is-there-a-way-to-boot-from-usb-through-grub-menu

```
Yes there is a way. First make sure you have secure boot disabled from the firmware settings. (The menu that opens when you press f2 during boot)
Then follow the following steps:

Press c when in grub menu to open command line
press ls to list all partitions in all hard drives
my output was as follows:

grub>ls 
(hd0) (hd0,gpt1) (hd1) (hd1,gpt8) (hd1,gpt7) (hd1,gpt6) (hd1,gpt5) (hd1,gpt4) (hd1,gpt3) (hd1,gpt2) (hd1,gpt1)
This clearly shows that my usb drive is hd0.

type ls (hd0,gpt1) to confirm:
Output is as follows:

grub>ls (hd0,gpt1) 
Partition hd0,gpt1: Filesystem type fat - Label `CES_X64FREV`, UUID 4099-DBD9 Partition start-512 Sectors...
Inplace of (hd0,gpt1) type the address of first partition of usb disk e.g: (hd1,gpt1) or (hd2,gpt1). According to output of ls command.

We need the UUID shown in the above line

Note the UUID of you usb drive.
Type the following commands one by one.

insmod part_gpt
insmod fat
insmod search_fs_uuid
insmod chain
search --fs-uuid --set=root 409-DBD9
In place of 4099-DBD9, write UUID which you noted down earlier.

Now we select the efi file to boot from. Type the following:

chainloader /efi/boot/bootx64.efi
Finally type boot

That's it, That should boot the usb drive.
```
