#!/bin/sh

# MariaDB 데이터베이스가 이미 설치되어 있는지 확인
if [ -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB 이미 초기화되었습니다."
else
    echo "MariaDB 초기화 중..."
    mariadb-install-db --datadir=/var/lib/mysql --auth-root-authentication-method=normal

    # 초기화 SQL 명령어 생성
    cat << EOF > /tmp/config.sql
    FLUSH PRIVILEGES;
    CREATE DATABASE IF NOT EXISTS $MARIADB_DB_NAME;
    CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PWD';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MARIADB_ROOT_PWD';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PWD';
    GRANT ALL PRIVILEGES ON $MARIADB_DB_NAME.* TO '$MARIADB_USER'@'%' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
EOF

    # MariaDB 부트스트랩 실행
    mariadbd --bootstrap < /tmp/config.sql

    # 권한 설정
    chown -R mysql:mysql /var/lib/mysql
fi

# MariaDB 실행
exec mariadbd --user=mysql --datadir=/var/lib/mysql
