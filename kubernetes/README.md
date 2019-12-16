Resources:

  - https://k3s.io/
  - https://rancher.com/blog/2019/2019-02-26-introducing-k3s-the-lightweight-kubernetes-distribution-built-for-the-edge/
  - https://rancher.com/blog/2019/2019-03-21-comparing-kubernetes-cni-providers-flannel-calico-canal-and-weave/
  - https://kubernetes.io/docs/reference/kubectl/cheatsheet/
  - https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/
  - https://medium.com/@chamilad/load-balancing-and-reverse-proxying-for-kubernetes-services-
  - https://github.com/rancher/k3d
  - https://testdriven.io/blog/running-vault-and-consul-on-kubernetes/
  
Components:

  - CNI
    - https://github.com/coreos/flannel
    - https://github.com/projectcalico/calico
  - https://github.com/coredns/coredns
  - https://github.com/containous/traefik
  - https://istio.io/
  
Download kubectl:
  - https://kubernetes.io/docs/tasks/tools/install-kubectl/
  
```
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```
  
  
Install k3s:

  - Download and install ubuntu VM
  - Take a snapshot
  - `curl -sfL https://get.k3s.io | sh -`
  
Install k3s from docker:
  - https://rancher.com/docs/k3s/latest/en/advanced/
  
Deploy web ui:
  - https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
  - does not work with another host than localhost

RBAC:
  - https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
  - https://kubernetes.io/docs/reference/access-authn-authz/authentication/
