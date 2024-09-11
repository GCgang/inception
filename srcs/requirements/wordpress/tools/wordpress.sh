#!/bin/sh

# 워드프레스가 설치되어 있는지 확인
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress 설치 중..."
    
    # WordPress 설치
    wp core download --allow-root --path=/var/www/html --force
    wp config create --allow-root --path=/var/www/html --dbhost=$MARIADB_HOST:$MARIADB_PORT --dbname=$MARIADB_DB_NAME --dbuser=$MARIADB_USER --dbpass=$MARIADB_PWD --force
    wp core install --allow-root --path=/var/www/html --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email
    wp user create --path=/var/www/html $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PWD --role=author
fi

# php-fpm 실행
exec php-fpm81 --nodaemonize
