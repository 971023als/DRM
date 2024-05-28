#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR

CODE [DBM-017] 업무상 불필요한 시스템 테이블 접근 권한 존재

cat << EOF >> "$result"
[양호]: 업무상 불필요한 시스템 테이블 접근 권한이 없는 경우
[취약]: 업무상 불필요한 시스템 테이블 접근 권한이 존재하는 경우
EOF

BAR

echo "지원하는 데이터베이스: MySQL, PostgreSQL"
read -p "Enter the type of your database (MySQL/PostgreSQL): " DB_TYPE

read -p "Enter the database username: " DB_USER
read -sp "Enter the database password: " DB_PASS
echo

case $DB_TYPE in
    MySQL|mysql)
        MYSQL_CMD="mysql -u $DB_USER -p$DB_PASS -Bse"
        SYSTEM_TABLE_PRIVILEGES=$($MYSQL_CMD "SELECT GRANTEE, TABLE_SCHEMA, PRIVILEGE_TYPE FROM information_schema.SCHEMA_PRIVILEGES WHERE TABLE_SCHEMA IN ('mysql', 'information_schema', 'performance_schema');")
        ;;
    PostgreSQL|postgresql)
        PSQL_CMD="psql -U $DB_USER -c"
        SYSTEM_TABLE_PRIVILEGES=$(PGPASSWORD=$DB_PASS $PSQL_CMD "SELECT grantee, table_schema, privilege_type FROM information_schema.role_table_grants WHERE table_schema = 'pg_catalog';")
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

if [ -z "$SYSTEM_TABLE_PRIVILEGES" ]; then
    OK "업무상 불필요한 시스템 테이블 접근 권한이 존재하지 않습니다."
else
    WARN "다음 사용자에게 업무상 불필요한 시스템 테이블 접근 권한이 부여되었습니다:"
    echo "$SYSTEM_TABLE_PRIVILEGES"
fi

cat "$result"

echo ; echo
