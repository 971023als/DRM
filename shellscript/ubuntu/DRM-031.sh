#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-031] SA 계정에 대한 보안설정 미흡

cat << EOF >> "$result"
[양호]: 관리자 계정의 보안 설정이 적절한 경우
[취약]: 관리자 계정의 보안 설정이 미흡한 경우
EOF

BAR

echo "지원하는 데이터베이스: 1. SQL Server 2. MySQL 3. PostgreSQL"
read -p "사용 중인 데이터베이스 유형을 선택하세요 (1-3): " DB_TYPE

read -p "데이터베이스 관리자 계정을 입력하세요: " DB_ADMIN
read -sp "데이터베이스 관리자 비밀번호를 입력하세요: " DB_PASS
echo

case $DB_TYPE in
    1)
        # SQL Server command
        DB_CMD="sqlcmd -U $DB_ADMIN -P $DB_PASS"
        QUERY="SELECT * FROM sys.sql_logins WHERE name = 'sa';"
        ;;
    2)
        # MySQL command
        DB_CMD="mysql -u $DB_ADMIN -p$DB_PASS -e"
        QUERY="SELECT User, Host FROM mysql.user WHERE User = 'root';"
        ;;
    3)
        # PostgreSQL command
        DB_CMD="psql -U $DB_ADMIN -c"
        QUERY="SELECT rolname FROM pg_roles WHERE rolname = 'postgres';"
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

# 관리자 계정의 보안 설정 확인
ADMIN_SECURITY_SETTINGS=$(echo "$QUERY" | $DB_CMD)

# 관리자 계정 보안 설정 검사
if [ -z "$ADMIN_SECURITY_SETTINGS" ]; then
    WARN "관리자 계정의 보안 설정이 미흡합니다."
else
    OK "관리자 계정의 보안 설정이 적절합니다: $ADMIN_SECURITY_SETTINGS"
fi

cat "$result"

echo ; echo
