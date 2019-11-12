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

`http://todo-app-<YOUR-NAME>.qjif7.k8s.gollum.westeurope.azure.gigantic.io`

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

### Pod Security Policies

MongoDB from our demo app is not working

- Check the error:

```
$ kubectl -n todo-app-<YOUR-NAME> get pods 

NAME                                        READY   STATUS    RESTARTS   AGE
todo-app-jgsqware-client-5f954c7cd9-5kzsq   1/1     Running   0          66s
todo-app-jgsqware-server-94b89c9b5-2t8g8    1/1     Running   1          66s


$ kubectl -n todo-app-<YOUR-NAME> get deployment todo-app-<YOUR-NAME>-mongodb

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
todo-app-jgsqware-mongodb   0/1     0            0           110s

$ kubectl -n todo-app-<YOUR-NAME> get replicaset -l app=mongodb
NAME                                  DESIRED   CURRENT   READY   AGE
todo-app-jgsqware-mongodb-99ccdbd76   1         0         0       2m55s

$ kubectl -n todo-app-<YOUR-NAME> describe replicaset -l app=mongodb

[...]

 Warning  FailedCreate  71s (x16 over 3m55s)  replicaset-controller  Error creating: pods "todo-app-jgsqware-mongodb-99ccdbd76-" is forbidden: unable to validate against any pod security policy: [spec.volumes[0]: Invalid value: "emptyDir": emptyDir volumes are not allowed to be used]
```

- Change the `todo-app/charts/mongodb/templates/_rbac.yaml` to `todo-app/charts/mongodb/templates/rbac.yaml` and upgrade the helm chart

```
helm upgrade todo-app-<YOUR-NAME> ./todo-app/
```

- Delete the failing replicaset to take the psp

```
kubectl -n todo-app-<YOUR-NAME> delete replicasets -l app=mongodb
```

### Network policies

- In our namespace, we want to deny all traffic (ingress, egress) from our pods

```
kubectl -n todo-app-<YOUR-NAME> apply -f network-policies/default-deny-all.yaml
```

- Kill the server pod and follow the logs of the backend to see the effect

```
$ kubectl -n todo-app-<YOUR-NAME> delete pod -l app=todo-app-<YOUR-NAME>-server
$ kubectl -n todo-app-<YOUR-NAME> logs -f -l app=todo-app-<YOUR-NAME>-server

2019/11/12 01:48:41 server selection error: server selection timeout
current topology: Type: Unknown
Servers:
Addr: todo-app-jgsqware-mongodb:27017, Type: Unknown, State: Connected, Average RTT: 0, Last error: connection() : dial tcp 172.31.239.101:27017: i/o timeout

```

- Allow traffic from Backend to DB

```
kubectl -n todo-app-<YOUR-NAME> apply -f network-policies/allow-backend-db.yaml
```

- Allow Ingress traffic to API and FrontEnd

```
kubectl -n todo-app-<YOUR-NAME> apply -f network-policies/allow-ingress.yaml
```
￼


### Cert-Manager

[Cert-Manager Setup](./cert-manager/setup.md)

### Harbor

[Harbor Setup](./harbor/setup.md)

### Open Policy Agent - Gatekeeper

[Open Policy Agent](./opa-gatekeeper/setup.md)

### Kube-Bench

[Kube-Bench](./kube-bench/setup.md)

### Dashboard

