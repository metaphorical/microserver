# Microserver

## Ideas

In pursuit for lightest microservice I am doing experiments in few languages and additionally few approaches within them.

It is mostly coming from my idea that I, few years ago, called "project 6", which was the idea around building web service in 6 different technologies (and no, nodejs and io, and js and ts do not count as different). IDK where number 6 came from... I had no idea which technologies I wanted to build it in. But now I got this list:

* NodeJS (hapi or koa)
* Python (flask or plain)
* Erlang (Cowboy + bare)
* Elixir (Phoenix + pure)
* golang
* c (KORE?)

At start notes here will be my own quick drops for myself... I hope to extend as myreasearch progresses

## Plan

* Build few microservices
* Make it weird but super fast, or something
* K8s
* Delivery
* Loadtest

## Erlang

It will be super fast.



### Basic

Just writing bare server in erlang - http server.

### Psycho

This counts as a bare solution since it is based of psycho server that was built by Garret Smith for his own usage and presented in one of his talks. Taking the idea (and a tool) from Garrett S., following what he did in his talk on building web server in erlang, logical extension is doing RnD on regular web microservice... 

Turned out I have put a pause on this one due to bad documentation... I can rather write my own routing and go with it then use what is there. At least it looks like it at this moment.

Rebar3 is tool of choice here so in most of cases:

```
rebar3 compile
rebar3 shell
```


### Cowboy

[Cowboy framework](https://github.com/ninenines/cowboy)

To run got to **erl_cowboy** directory and run:

```
make run
```

## Development notes

### Minikube setup

To setup k8s locally you will ideally use [**minikube**](https://kubernetes.io/docs/setup/minikube/).

#### Container registry mess

You need to build your docker image and push it to container registry in order for deployment to work as it would out there.

> Can also be used for custom/non cloud kubernetes deployments (if those still exit somewhere at the time of reading)

Easiest way to set local test is using either docker container registry, aws ecr or google container registry. 

There are tutorials on the internet to setup local container registry, but then you need to hack around certificates etc so... swallow some upload time or find mentioned tuts.

To use one of these container registries, you can simply use minikube addon called **registry-creds**. 

> For non mini kube install you can go to [registry creds]() repo and clone it, heads up tho - it is not too frequently maintained and docs are terrible.

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

Refer to one of [deployment manifests](erl_cowboy/deployment/erlc_deployment.yaml)