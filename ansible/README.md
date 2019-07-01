### Lookup module return

The default behavior of lookup is to return a string of comma separated values. lookup can be explicitly configured to return a list using `wantlist=True`

### Execute remote bash script without copying the file

Set arguments after `-s`

```
#!/bin/bash
echo $@
```

```
---
- hosts: localhost
  gather_facts: no
  tasks:
    - command: bash -s blih blah bluh
      args:
        stdin: "{{ lookup('file', '/tmp/blih.sh') }}"
      register: blih
    - debug:
        msg: "{{ blih.stdout }}"
```

### Random uuid

```
{{ (2 ** 64) | random | string | to_uuid }}
```
