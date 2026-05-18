# FROM alpine:latest
FROM alpine:3.22.4

LABEL maintainer="szymon"

RUN apk --no-cache add nginx \
    && apk --no-cache add openssl \
    && apk --no-cache add bash \
    && apk --no-cache add curl

WORKDIR /var/www/html
COPY ./nginx.conf /etc/nginx/nginx.conf 
RUN mkdir -p /var/www/assets \
    && chown -R nginx:nginx /var/www/html \
    && chown -R nginx:nginx /var/www/assets

COPY ./index.html /var/www/html/index.html
COPY ./assets /var/www/html/assets
COPY ./style.css /var/www/html/style.css


EXPOSE  80
EXPOSE  443

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=PL/ST=Dolnoslaskie/L=Wroclaw/O=ND/OU=IT/CN=hosting.local"

CMD ["nginx", "-g", "daemon off;"]
