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

## kubernetes

### Deployment

> Please note that deployment is tweaked a bit for local testing, if there are not two clearly marked deployment manifests, it is for local.

Assuming you got "microserver" namespace set
```
kubectl create -f deployment/erlc_deployment.yaml -n microserver
```
To delete deployment
```
kubectl delete -f deployment/erlc_deployment.yaml -n microserver
```


## API

/ - root
/:id - returning :id