FROM alpine:3.17

WORKDIR /var/www/html

# 필요한 패키지 설치
RUN apk update && \
    apk add --no-cache curl dumb-init php81 php81-fpm php81-mysqli php81-xml php81-gd php81-intl php81-iconv php81-phar mariadb-client

# WP-CLI 다운로드 및 실행 권한 부여
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

# www-data 유저 및 그룹 추가
RUN addgroup -g 81 -S www-data || true && \
    adduser -u 81 -D -S -G www-data www-data || true


# php-fpm 설정 파일 복사
COPY conf/www.conf /etc/php81/php-fpm.d/www.conf

# 스크립트 파일 복사 및 권한 설정
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh
RUN chmod +x /usr/local/bin/wordpress.sh

# 권한 설정
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# 포트 설정
EXPOSE 9000

# 엔트리포인트 설정
ENTRYPOINT ["dumb-init", "--", "/usr/local/bin/wordpress.sh"]
