# Cowboy framework implementation

[Cowboy framework](https://github.com/ninenines/cowboy)

## Running locally

If you have everythng brewed into your OS:

```
make 
make run
```

Better choice is using Docker:

```
docker build . -t erlc
docker run -p 8080:8080 -it --name erlc erlc
```

Cleanup docker to be able to rebuild and rerun:

```
docker stop erlc | docker rm erlc
```

## Kubernetes

> Deployments/values are set up for local deployment that expects local host **microserver.erlang** to be set
>
> ```
> echo "$(minikube ip) microserver.erlang" | sudo tee -a /etc/hosts
> ```
>
> If yoook at Root readme for how to set up docker registry and everythong needed in local, expected image name is **microserver/erlang** (take a look into files, anyways)


### Creating full deployment

```
kubectl create -f deployment/service.yaml && kubectl create -f deployment/deployment.yaml && kubectl create -f deployment/ingress.yaml
```

### Deleting deployment

```
kubectl delete -f deployment/service.yaml && kubectl delete -f deployment/deployment.yaml && kubectl delete -f deployment/ingress.yaml
```



## API

- / - root
- /healthy - returning header **X-Health:Awsome** - used for liveness http get probe
- /:id - returning :id