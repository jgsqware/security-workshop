# Open Policy Agent Setup

## Create Needed resources

```
kubectl create namespace production
kubectl create namespace staging
```

- Pull,Tag and push `nginx` image to your registry: 

    ```
    docker pull nginx
    docker tag nginx core.h5vak.k8s.gollum.westeurope.azure.gigantic.io/security-workshop/nginx
    docker push core.h5vak.k8s.gollum.westeurope.azure.gigantic.io/security-workshop/nginx
    ```

## Set your ImagePullSecret from local registry

```
    cp ~/.docker/config.json .
```

Edit the file to remove you registry and keep only the harbor one:

```
{
"auths": {
	"core.jtac8.k8s.gollum.westeurope.azure.gigantic.io": {
		"auth": "YWRtaW46SGFyYm9yMTIzNDU="
	}
},
"HttpHeaders": {
	"User-Agent": "Docker-Client/19.03.4-ce (linux)"
}
}
```

Create the secret:

```
kubectl create secret generic harbor-registry \
    --from-file=.dockerconfigjson=./config.json \
    --type=kubernetes.io/dockerconfigjson \
    -n production
```

## Setup Gatekeeper

```
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
```

Install Allowed Repo template:

```
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/demo/agilebank/templates/k8sallowedrepos_template.yaml
```

Install Allowed Repo effective constraint that block other registries than harbor one in `production` namespace:

```
kubectl apply -f ./repoConstraint.yaml
```

## Test Gatekeeper

- Create a Nginx deployment from `docker hub` `nginx` image in `Staging`:

    ```
    kubectl apply -f repoConstraint-staging-good.yaml
    ```

- Check if pods is running


- Create a Nginx deployment from `docker hub` `nginx` image in `Production`:

    ```
    kubectl apply -f repoConstraint-prod-bad.yaml

    Error from server ([denied by prod-repo-is-harbor] container <nginx> has an invalid image repo <nginx:latest>, allowed repos are ["core.jtac8.k8s.gollum.westeurope.azure.gigantic.io"]): error when creating "../opa-gatekeeper/repoConstraint-prod-bad.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [denied by prod-repo-is-harbor] container <nginx> has an invalid image repo <nginx:latest>, allowed repos are ["core.jtac8.k8s.gollum.westeurope.azure.gigantic.io"]
    ```

- Create a Nginx deployment from `harbor` `nginx` image in `Production`:

    ```
    kubectl apply -f repoConstraint-prod-good.yaml
    ```

- Check if pods is running

## Clean up

```
kubectl delete namespace production
kubectl delete namespace staging
```



kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/demo/basic/sync.yaml

Limits