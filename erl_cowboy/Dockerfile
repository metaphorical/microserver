FROM erlang:latest

WORKDIR /usr/src/app

COPY . .

EXPOSE 8080

RUN "make"

CMD ["make", "run"]