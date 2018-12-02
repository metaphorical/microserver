# Microserver

In pursuit for lightest microservice I am doing experiments in few languages and additionally few approaches within them.

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

Rebar3 is tool of choice here so in most of cases:

```
rebar3 compile
rebar3 shell
```

Taking the idea (and a tool) from Garrett Smith, following what he did in his talk on building web server in erlang, logical extension is doing RnD on regular web microservice... Something that gets hit a lot?

Turned out I have put a pause on this one due to bad documentation... I can rather write my own routing and go with it then use what is there. At least it looks like it at this moment.


### Cowboy

(Cowboy framework)[https://github.com/ninenines/cowboy]

To run got to **erl_cowboy** directory and run:

```
make run
```