FROM alpine:3.17

RUN apk update && \
    apk add --no-cache nginx openssl dumb-init

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN openssl req \
    -x509 \
    -nodes \
    -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/cert.key \
    -out /etc/nginx/cert.crt \
    -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/CN=hyeoan"

EXPOSE 443

ENTRYPOINT [ "dumb-init", "--", "nginx", "-g", "daemon off;" ]

