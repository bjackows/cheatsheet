## Switch namespace for current context

```
kubectl config set-context --current --namespace=my-namespace
```

## Drain node

```
kubectl drain ip-172-31-10-226.ec2.internal --ignore-daemonsets --delete-local-data
```
