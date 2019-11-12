# Harbor Setup

## Create needed resources

- Set ENV vor with the ingress domain:

    `export HARBOR_DOMAIN="<YOUR-NAME>.qjif7.k8s.gollum.westeurope.azure.gigantic.io"`


- Helm:

    ```
    sed s/{{DOMAIN}}/$HARBOR_DOMAIN/g ./harbor/values.yaml | helm install --name harbor-<YOUR-NAME> --namespace harbor-<YOUR-NAME> -f - ./harbor/helm
    ```

- Watch Harbor pods running:

    ```
    watch kubectl get pods -n harbor-<YOUR-NAME>

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

- Login to the portal: https://core.<YOUR-NAME>.qjif7.k8s.gollum.westeurope.azure.gigantic.io
- Create project: `securityworkshop`
- Login to regsitry with docker:
    
    ```
    docker login --username admin core.<YOUR-NAME>.qjif7.k8s.gollum.westeurope.azure.gigantic.io
    ```

- Pull,Tag and push vulnerable image to your registry: 

    ```
    docker pull nginx:1.12-alpine
    docker tag nginx:1.12-alpine core.<YOUR-NAME>.qjif7.k8s.gollum.westeurope.azure.gigantic.io/securityworkshop/nginx:1.12-alpine
    docker push core.<YOUR-NAME>.qjif7.k8s.gollum.westeurope.azure.gigantic.io/securityworkshop/nginx:1.12-alpine
    ```

## Check vulnerabilities on the portal

## Clean up

```
helm delete --purge harbor
```
