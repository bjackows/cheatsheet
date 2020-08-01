# Kustomize generator that uses linkerd install with --ignore-cluster
# to generate kubernetes manifests for gitops


File: `kustomize/linkerd/v0.0.1/install/install`
```
#!/usr/bin/env python3

# Vars:
#		metadata.name: Dummy value
#		flags: list of flags to pass to linkerd install

# Dependencies:
#		- python3

import yaml
import sys
import os

if len(sys.argv) < 2:
	sys.stderr.write('Missing kustom variable file\n')
	sys.exit(2)

kustom_file = sys.argv[1]

with open(kustom_file) as file:
	kustom_values = yaml.load(file, Loader=yaml.SafeLoader)

env = os.environ.copy()

flags = []

if 'flags' in kustom_values:
	if type(kustom_values['flags']) != list:
		raise('flags is not a list')
	flags = kustom_values['flags']

import subprocess
subprocess.run(['linkerd', 'install', '--ignore-cluster'] + flags + ['--ignore-cluster'], env=env, stdout=None, stderr=None)
```

File: `kustomization.yaml`
```
---
generators:
  - install.yaml
```

File: `install.yaml`

If you don't generate the certificates yourself, linkerd will generate one for you every time you run kustomize
```
---
apiVersion: linkerd/v0.0.1
kind: install
metadata:
  name: linkerd-install
flags:
  - -L
  - infrastructure-linkerd
  - --addon-config
  - ./config.yaml
  - --identity-trust-anchors-file
  - ca.crt
  - --identity-issuer-certificate-file
  - issuer.crt
  - --identity-issuer-key-file
  - issuer.key
```
