# Example using a job to perform deployment restart using gitops

Example deployment

```
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 5 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

Create a job to perform the rollout restart. Use kubectl image along with custom rbac to do the action. The job is better run in the same namespace.

Delete the job when it is done so it does not restart in casse of disaster recovery.

```
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: restart-deployment
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: restart-deployment
  namespace: default
rules:
  - apiGroups: ["apps"]
    resources: ["deployments"]
    verbs: ["get", "patch"] # change this
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: restart-deployment-to-sa
  namespace: default
subjects:
  - kind: ServiceAccount
    name: restart-deployment
roleRef:
  kind: Role
  name: restart-deployment
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: batch/v1
kind: Job
metadata:
  name: testing-stuff
  namespace: default
spec:
  template:
    metadata:
      name: restarter
    spec:
      serviceAccountName: restart-deployment
      containers:
      - name: restarter
        image: bitnami/kubectl:1.17.3
        command:
        - kubectl
        - -n
        - default
        - rollout
        - restart
        - deployment/nginx-deployment
      restartPolicy: Never 
```
