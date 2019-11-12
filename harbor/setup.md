# Harbor Setup

## Create needed resources

- Set ENV vor with the ingress domain:

    export HARBOR_DOMAIN="iaa8w.k8s.ginger.eu-central-1.aws.gigantic.io"


- Helm:

    ```
    sed s/{{DOMAIN}}/$HARBOR_DOMAIN/g values.yaml | helm install --name harbor --namespace harbor -f - ./helm
    ```

- Watch Harbor pods running:

    ```
    watch kubectl get pods -n harbor

    NAME                                      READY   STATUS              RESTARTS   AGE
    harbor-harbor-clair-55cf4dbbb7-vzs4s      2/2     Running             0          46s
    harbor-harbor-core-6d9df6dc78-hhjhq       1/1     Running             0          46s
    harbor-harbor-database-0                  1/1     Running             0          46s
    harbor-harbor-jobservice-b59c5d5b-nv54p   1/1     Running             0          46s
    harbor-harbor-portal-76f9657d9c-pfwz8     1/1     Running             0          46s
    harbor-harbor-redis-0                     1/1     Running             0          46s
    harbor-harbor-registry-6b4ff8d494-8wf8j   2/2     Running             0          46s
    ```

## Upload images

- Login to the portal: https://core.iaa8w.k8s.ginger.eu-central-1.aws.gigantic.io
- Create project: `Security Workshop`
- Login to regsitry with docker:
    
    ```
    docker login --username admin core.h5vak.k8s.gollum.westeurope.azure.gigantic.io
    ```

- Pull,Tag and push vulnerable image to your registry: 

    ```
    docker pull quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.26.1
    docker tag quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.26.1 core.h5vak.k8s.gollum.westeurope.azure.gigantic.io/kubernetes-ingress-controller/nginx-ingress-controller:0.26.1
    docker push core.h5vak.k8s.gollum.westeurope.azure.gigantic.io/kubernetes-ingress-controller/nginx-ingress-controller:0.26.1
    ```

## Check vulnerabilities on the portal

## Clean up

```
helm delete --purge harbor && k delete pvc  -n harbor --all
```