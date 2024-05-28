#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-029] 데이터베이스의 자원 사용 제한 설정 미흡

cat << EOF >> "$result"
[양호]: 데이터베이스의 자원 사용 제한이 적절하게 설정된 경우
[취약]: 데이터베이스의 자원 사용 제한이 미흡한 경우
EOF

BAR

echo "지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle"
read -p "사용 중인 데이터베이스 유형을 선택하세요 (1-3): " DB_TYPE

read -p "데이터베이스 사용자 이름을 입력하세요: " DB_USER
read -sp "데이터베이스 비밀번호를 입력하세요: " DB_PASS
echo

case $DB_TYPE in
    1)
        DB_CMD="mysql -u $DB_USER -p$DB_PASS -e"
        QUERY="SHOW VARIABLES LIKE 'max_connections';"
        ;;
    2)
        DB_CMD="psql -U $DB_USER -c"
        QUERY="SHOW max_connections;"
        ;;
    3)
        DB_CMD="sqlplus -s $DB_USER/$DB_PASS"
        QUERY="SHOW PARAMETERS sessions;"
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

# 데이터베이스 자원 사용 제한 설정 확인
RESOURCE_LIMITS=$(echo "$QUERY" | $DB_CMD)

# 자원 사용 제한 설정 검사
if [ -z "$RESOURCE_LIMITS" ]; then
    WARN "데이터베이스 자원 사용 제한 설정이 미흡합니다."
else
    OK "데이터베이스 자원 사용 제한 설정이 적절합니다: $RESOURCE_LIMITS"
fi

cat "$result"

echo ; echo
