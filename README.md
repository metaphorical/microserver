![project microserver](./misc/logo.png "Microserver")

# Microserver - the learning project


## Ideas

Going beyong thought experment in pursuit for lightest, fastest, most scalable and cost effective technology to develop microservices in I am doing experiments in few languages and additionally few approaches within them. I am mostly sticking with technologies I worked with in last several years (not always necesserily for the web). Idea is to provide a learning/teaching base for deeper understanding of developing scalable and fault tolerant systems that live on the internet.

It is mostly coming from my idea that I, few years ago, called "project 6", which was the idea around building web service in 6 different technologies (and no, nodejs and io, and js and ts do not count as different, I am also avoiding PHP due to architectural preferences). IDK where number 6 came from... I had no idea which technologies I wanted to build it in. But now I got this list:

> **Tagging:** By the name of every implementation you will find tag local/full/wip which will tell you if the particular approach is done just locally as part of research (and then probably dropped) or it is fully containerized and prepared for deployment in k8s.

* NodeJS
  * hapi[wip]
  * koa[wip]
* Python (flask or plain)
* Erlang - Cowboy[full]
* Elixir (Phoenix and no framework)
* golang[wip]
* c - Kore[wip]

At start notes here will be my own quick drops for myself... I hope to extend as my reasearch progresses.

## Plan

* Build few microservices
* Make it weird but super fast, or something
* K8s + Helm (:+istio?)
* Delivery
* Loadtest

## Erlang(Cowboy)(erlang/readme.md)

## NodeJS

* [hapi](nodejs/hapi/readme.md)
* [koa](nodejs/koa/readme.md)

## C

* [Kore](c/kore/readme.md)

## [Go](golang/readme.md)



## Development environment notes
> If you want to know how to run it, every sevice has its own notes inside its directory, these are genera notes that will help you understand environment setup little more in depth.

### Minikube setup

To setup k8s locally you will ideally use [**minikube**](https://kubernetes.io/docs/setup/minikube/).

This docuemntation assuems that you understand basic k8s stuff.

#### Rough reality of container registry usage

You need to build your docker image and push it to container registry in order for deployment to work as it would out there.

##### Local, easier option
> But missing setup/usage of real container registry so you would lack that wxpwriance when you move forward.

**Here is it step by step:**

* Get your docker context into your minikube cluster

```
$ eval $(minikube docker-env)
```

> you can later revert this by using
>
> ```
> $ eval $(docker-machine env -u)
> ```


* While in cluster context setup local docker registry

```
$ docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

This should setup internal docker registry on localhost:5000 so you can build and prepare images with (<> marks where your values go):

```
$ docker build . -t <your_tag>
$ docker tag <your_tag> localhost:5000/<your_tag>:<version>
```

* At this point you can **use localhost:5000/<your_tag>:<version>** as image in your deployment and that is it.

##### Proper, with real container registry
> Can also be used for custom/non-cloud kubernetes deployments (if those still exit somewhere at the time of reading).

Easiest way to set local test is using either docker container registry, aws ecr or google container registry.

There are tutorials on the internet to setup local container registry, but then you need to hack around certificates etc so... swallow some upload time or find mentioned tuts.

To use one of these container registries, you can simply use minikube addon called **registry-creds**.

> For non mini kube install you can go to [registry creds](https://github.com/upmc-enterprises/registry-creds) repo and clone it, heads up tho - it is not too frequently maintained and docs are terrible.

```
$ minikube addons configure registry-creds
$ minikube addons enable registry-creds
```

> Make sure that, if you are setting it for AWS ECR, and you do not have role arn you want to use (you usually wont have and it is optional), you set it as something random as "changeme" or smt... It requires value, if you just press enter (since it is optional) deployment of creds pod will fail and make your life miserable.

In case of AWS ECR, that will let you pull from your repo directly setting url as container image and adding pull secret named **awsecr-cred**:
```
imagePullSecrets:
      - name: awsecr-cred
```

Refer to one of [deployment manifests](erlang/deployment/deployment.yaml)

#### Ingress

```
$ minikube addons enable ingress
```

Make sure that you setup ingress based on your local hosts. For me, for example, it means adding following lines to /etc/hosts:

```
[minikube ip] microserver.erlang microserver.elixir microserver.c
```
Where **"[minikube ip]"** should be replaced with actual minikube ip.

Here is shortcut to do it:

```
$ echo "$(minikube ip) microserver.erlang" | sudo tee -a /etc/hosts
```

### Helm

When you are setting up stuff, you will need helm so, have minikube on and:

```
$ brew install kubernetes-helm
$ helm init
```
Valuable read: [https://docs.helm.sh/using_helm/](https://docs.helm.sh/using_helm/)

## Kubernetes deployment

### Project helm chart

> At this moment helm chart deploys one application to kubernetes with ingress and backend it needs. There is no out-of-the-box ability to run multiple apps on same ingress - I will probably add that later.

This project provides global template to run microserver apps in kubernetes in form of a helm chart.

Every app needs [values file](erlang/deployment/values.yaml) for general app deployment properties.

When you setup desired deployment properties for your app you can deploy it to k8s using:

Create:
```
helm upgrade -i --force microserver-erlang ./deployment/ --values ./erlang/deployment/values.yaml
```
delete:
```
helm delete microserver-erlang --purge
```