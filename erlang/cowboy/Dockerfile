FROM erlang:alpine

WORKDIR /usr/src/app

RUN apk update \
    && apk add --virtual build-dependencies \
        build-base \
        gcc \
        wget \
        git \
        curl \
    && apk add \
        bash \
    && apk add --update make

COPY . .

EXPOSE 8080

RUN make

CMD ["./_rel/erl_cowboy_release/bin/erl_cowboy_release", "foreground"]