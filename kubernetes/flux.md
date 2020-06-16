### Deploy flux with helm quickly
```
git clone https://github.com/fluxcd/flux
cd flux/chart/flux
helm template \
  --release-name fluxcd \
  --set git.url=git@github.com:tehmoon/flux-test \
  --set git.readonly=true \
  --set sync.state=secret \
  --set git.pollInterval=10s \
  --set syncGarbageCollection.enabled=true | kubectl apply -f -
fluxctl identity
```
