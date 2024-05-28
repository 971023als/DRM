#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-030] Audit Table에 대한 접근 제어 미흡

cat << EOF >> "$result"
[양호]: Audit Table에 대한 접근 제어가 적절하게 설정된 경우
[취약]: Audit Table에 대한 접근 제어가 미흡한 경우
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
        QUERY="SELECT * FROM audit_table_permissions;" # 실제 쿼리는 데이터베이스와 요구사항에 따라 다를 수 있음
        ;;
    2)
        DB_CMD="psql -U $DB_USER -c"
        QUERY="SELECT * FROM audit_table_permissions;" # 실제 쿼리는 데이터베이스와 요구사항에 따라 다를 수 있음
        ;;
    3)
        DB_CMD="sqlplus -s $DB_USER/$DB_PASS"
        QUERY="SELECT * FROM audit_table_permissions;" # 실제 쿼리는 데이터베이스와 요구사항에 따라 다를 수 있음
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

# Audit Table 접근 제어 설정 확인
AUDIT_ACCESS=$(echo "$QUERY" | $DB_CMD)

# 접근 제어 설정 검사
if [ -z "$AUDIT_ACCESS" ]; then
    WARN "Audit Table에 대한 접근 제어가 미흡합니다."
else
    OK "Audit Table에 대한 접근 제어가 적절합니다: $AUDIT_ACCESS"
fi

cat "$result"

echo ; echo
