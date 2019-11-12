# Kube-Bench Kubernetes run

## Create Needed resources

```
kubectl create namespace kube-bench
kubectl apply -n kube-bench -f ./rbac.yaml

```

## Run the job

```
kubectl apply -n kube-bench -f ./job.yaml
kubectl -n kube-bench logs --tail=1000 -l app=kube-bench
```

## Clean up

```
kubectl delete namespace kube-bench
```