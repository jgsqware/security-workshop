# Open Policy Agent Setup

## Create Needed resources

```
kubectl create namespace production-<YOUR-NAME>
kubectl create namespace staging-<YOUR-NAME>
```


## Set your ImagePullSecret from local registry

```
    cp ~/.docker/config.json .
```

Edit the file to remove you registry and keep only the harbor one:

```
{
"auths": {
	"core.<YOUR-NAME>.qjif7.k8s.gollum.westeurope.azure.gigantic.io": {
		"auth": "your auth token"
	}
},
"HttpHeaders": {
	"User-Agent": "Docker-Client/19.03.4-ce (linux)"
}
}
```

Create the secret:

```
kubectl -n gatekeeper-system-<YOUR-NAME> create secret generic harbor-registry \
    --from-file=.dockerconfigjson=./config.json \
    --type=kubernetes.io/dockerconfigjson \
    -n production-<YOUR-NAME>
```

## Setup Gatekeeper

- Install Gatekeeper in your namespace 

```
YOURNAME=<YOUR-NAME>;  sed s/\<YOUR-NAME\>/$YOURNAME/g ./opa-gatekeeper/gatekeeper.yaml | kubectl apply -f -
```

- Install Allowed Repo template:

```
kubectl -n gatekeeper-system-<YOUR-NAME> apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/demo/agilebank/templates/k8sallowedrepos_template.yaml
```

- Enable Sync Audit

```
kubectl -n gatekeeper-system-<YOUR-NAME> apply -f ./opa-gatekeeper/sync.yaml
```

- Install Allowed Repo effective constraint that block other registries than harbor one in `production` namespace:

```
YOURNAME=<YOUR-NAME>;  sed s/\<YOUR-NAME\>/$YOURNAME/g ./opa-gatekeeper/registry/repoConstraint.yaml | kubectl apply -f -
```

## Test Gatekeeper

### Registry limitation

- Create a Nginx deployment from `docker hub` `nginx` image in `Staging`:

    ```
    kubectl -n staging-<YOUR-NAME> apply -f opa-gatekeeper/registry/repoConstraint-staging-good.yaml
    ```

- Check if pods is running


- Create a Nginx deployment from `docker hub` `nginx` image in `Production`:

    ```
    kubectl -n production-<YOUR-NAME> apply -f opa-gatekeeper/registry/repoConstraint-prod-bad.yaml

    Error from server ([denied by prod-repo-is-harbor] container <nginx> has an invalid image repo <nginx:latest>, allowed repos are ["core.jtac8.k8s.gollum.westeurope.azure.gigantic.io"]): error when creating "../opa-gatekeeper/repoConstraint-prod-bad.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [denied by prod-repo-is-harbor] container <nginx> has an invalid image repo <nginx:latest>, allowed repos are ["core.jtac8.k8s.gollum.westeurope.azure.gigantic.io"]
    ```

- Create a Nginx deployment from `harbor` `nginx` image in `Production`:

    ```
    YOURNAME=<YOUR-NAME>;  sed s/\<YOUR-NAME\>/$YOURNAME/g opa-gatekeeper/registry/repoConstraint-prod-good.yaml | kubectl -n production-$YOURNAME apply -f -
    ```

- Check if pods is running

### Audit feature with request limit

## Clean up

```
kubectl delete namespace production-<YOUR-NAME>
kubectl delete namespace staging-<YOUR-NAME>
```




