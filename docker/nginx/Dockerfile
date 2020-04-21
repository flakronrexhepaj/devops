FROM alpine:3.8

RUN apk update && apk add nginx openrc

ADD config/default.conf /etc/nginx/conf.d/default.conf
ADD config/nginx.conf /etc/nginx/nginx.conf