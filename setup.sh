#!/bin/bash 

kubectl create serviceaccount tiller --namespace kube-system
kubectl create -f /home/jgsqware/go/src/github.com/jgsqware/notes/tiller-rbac/tiller-clusterrolebinding.yaml
helm init --service-account tiller --upgrade
