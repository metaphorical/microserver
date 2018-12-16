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

### Minikube images

If you are running services in k8s and want to test setup locally using **minikube**, you probably would not like to have ot uploade everything you build to your docker registry.

Ideally you would avoid all the fuss and just deliver image to minikube.

This can be done by building images directly into minikube cluster, by executing:

```
eval $(minikube docker-env)
```

Afret executing this your docker context is minikube environment. Now you can build the image under whatever tag/name you want and reference it in your k8s manifest.

TA-DAAAAH