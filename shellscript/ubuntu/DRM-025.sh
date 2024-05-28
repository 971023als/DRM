#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-025] 서비스 지원이 종료된(EoS) 데이터베이스 사용 확인

cat << EOF >> "$result"
[양호]: 현재 사용 중인 데이터베이스 버전이 지원되는 경우
[취약]: 현재 사용 중인 데이터베이스 버전이 서비스 지원 종료(EoS) 상태인 경우
EOF

BAR

echo "지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle"
read -p "사용 중인 데이터베이스 유형을 선택하세요 (1-3): " DB_TYPE

case $DB_TYPE in
    1)
        read -p "Enter MySQL root username: " MYSQL_USER
        read -sp "Enter MySQL root password: " MYSQL_PASS
        echo
        MYSQL_VERSION=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" -e "SELECT VERSION();" | grep -v 'VERSION')
        if [[ "$MYSQL_VERSION" == "5.6.40" ]]; then
            WARN "MySQL 버전 $MYSQL_VERSION 는 서비스 지원이 종료된 버전입니다."
        else
            OK "현재 MySQL 버전은 지원되는 버전입니다."
        fi
        ;;
    2)
        read -p "Enter PostgreSQL username: " PGSQL_USER
        read -sp "Enter PostgreSQL password: " PGSQL_PASS
        echo
        PGSQL_VERSION=$(psql -U "$PGSQL_USER" -c "SELECT version();" | grep PostgreSQL | awk '{print $3}')
        # Replace this with actual check against known EoS versions for PostgreSQL
        echo "PostgreSQL 버전 확인: $PGSQL_VERSION"
        ;;
    3)
        echo "Oracle 데이터베이스 버전 확인 로직을 여기에 구현합니다."
        # Implement Oracle version check here
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

cat "$result"

echo ; echo
