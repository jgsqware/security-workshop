# Security Workshop

## Setup

### Pre-Requisite

- Helm
- kubectl
- docker

### Example app deployment

- Install `Todo-app` with Helm in your namespace

```
$ helm install --name todo-app-<YOUR-NAME> --namespace todo-app-<YOUR-NAME> ./todo-app
```

- Check your pod status

```
$ watch kubectl -n todo-app-<YOUR-NAME> get pods 
```

- When everything is running, open a browser to the address

http://todo-app-<YOUR-NAME>.qjif7.k8s.gollum.westeurope.azure.gigantic.io

### RBAC

- Create a Role to allow a specific user to have READ-ONLY role on a specific namespace `rbac-example-<YOUR-NAME>`

```
kubectl create namespace rbac-example-<YOUR-NAME>
kubectl create serviceaccount -n rbac-example-<YOUR-NAME> myuser
kubectl create rolebinding -n rbac-example-<YOUR-NAME> myuser-view --clusterrole=view --serviceaccount=rbac-example-<YOUR-NAME>:myuser

alias kubectl-user='kubectl --as=system:serviceaccount:rbac-example-<YOUR-NAME>:myuser'

kubectl-user get pod -n rbac-example-<YOUR-NAME>
kubectl-user get pod
kubectl get pod
```

- Check that this user don't have access to other namespace

```
kubectl-user auth can-i get pods -n default
```

- Grant access to default namespace to that user

```
kubectl create rolebinding -n default myuser-default-view --clusterrole=view --serviceaccount=rbac-example-<YOUR-NAME>:myuser
kubectl-user auth can-i get pods -n default
kubectl-user get pod
kubectl-user auth can-i get pods --all-namespaces
```

- Tear Down

```
kubectl delete namespace rbac-example-<YOUR-NAME>
kubectl delete rolebinding -n default myuser-default-view
```

### Cert-Manager

[Cert-Manager Setup](./cert-manager/setup.md)

### Harbor

[Harbor Setup](./harbor/setup.md)

### Open Policy Agent - Gatekeeper

[Open Policy Agent](./opa-gatekeep/setup.md)

### Kube-Bench

[Kube-Bench](./kube-bench/setup.md)

### Dashboard

