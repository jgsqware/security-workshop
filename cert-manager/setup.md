# Cert-Manager Setup

## Create needed resources

- Namespace:
  
  ```
  kubectl create namespace cert-manager-<YOUR-NAME>
  ```

- CRDs:

  ```
  kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml
  ```

- Helm repository:

  ```
  helm repo add jetstack https://charts.jetstack.io
  helm repo update
  ```

- Install:

  ```
  helm install \
    --name cert-manager \
    --namespace cert-manager-<YOUR-NAME> \
    --version v0.11.0 \
    jetstack/cert-manager
  ```

## Test your setup

- Watch all pods are running:

  ```
  watch kubectl get pods -n cert-manager-<YOUR-NAME>

  cert-manager-55fff7f85f-qgmhk              1/1     Running   0          36s
  cert-manager-cainjector-54c4796c5d-hx8lc   1/1     Running   0          36s
  cert-manager-webhook-77ccf5c8b4-hdttw      1/1     Running   1          36s

  ```

- Test resource creation:

  ```
    kubectl create namespace cert-manager-<YOUR-NAME>-test
    kubectl -n cert-manager-<YOUR-NAME>-test apply -f ./cert-manager/test-resources.yaml
  ```

- Check the status of the newly created certificate

> You may need to wait a few seconds before cert-manager processes the certificate request

```
kubectl describe certificate -n cert-manager-<YOUR-NAME>-test
...
Spec:
  Common Name:  example.com
  Issuer Ref:
    Name:       test-selfsigned
  Secret Name:  selfsigned-cert-tls
Status:
  Conditions:
    Last Transition Time:  2019-01-29T17:34:30Z
    Message:               Certificate is up to date and has not expired
    Reason:                Ready
    Status:                True
    Type:                  Ready
  Not After:               2019-04-29T17:34:29Z
Events:
  Type    Reason      Age   From          Message
  ----    ------      ----  ----          -------
  Normal  CertIssued  4s    cert-manager  Certificate issued successfully
```

- Clean up the test resources

  ```
  kubectl delete namespace cert-manager-<YOUR-NAME>-test
  ```

- Deploy resource

  Replace with your email in the two following resource file than apply:
  ```
  kubectl -n cert-manager-<YOUR-NAME> apply -f ./cert-manager/cluster-issuer-lets-encrypt-staging.yaml -f ./cert-manager/cluster-issuer-lets-encrypt.yaml
  ```
  