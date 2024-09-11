FROM alpine:3.17

RUN apk update && \
	apk add --no-cache mariadb mariadb-client dumb-init

RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY conf/my.cnf /etc/my.cnf

COPY tools/mariadb.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306

ENTRYPOINT [ "dumb-init", "--", "/usr/local/bin/mariadb.sh"]