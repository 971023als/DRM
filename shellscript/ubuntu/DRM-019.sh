#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR

CODE [DBM-019] 비밀번호 재사용 방지 설정 미흡

cat << EOF >> "$result"
[양호]: 비밀번호 재사용 방지가 올바르게 설정된 경우
[취약]: 비밀번호 재사용 방지가 제대로 설정되지 않은 경우
EOF

BAR

echo "지원하는 데이터베이스: MySQL, PostgreSQL"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

read -p "데이터베이스 사용자 이름을 입력하세요: " DB_USER
read -sp "데이터베이스 비밀번호를 입력하세요: " DB_PASS
echo

case $DB_TYPE in
    MySQL|mysql)
        DB_CMD="mysql -u $DB_USER -p$DB_PASS -Bse"
        QUERY="SELECT VARIABLE_VALUE FROM information_schema.global_variables WHERE VARIABLE_NAME = 'validate_password_history';"
        ;;
    PostgreSQL|postgresql)
        DB_CMD="psql -U $DB_USER -c"
        QUERY="SHOW password_encryption;"
        # PostgreSQL의 경우, 비밀번호 재사용 방지 정책은 다른 방식으로 설정될 수 있음을 주의하세요.
        ;;
    *)
        echo "지원하지 않는 데이터베이스 유형입니다."
        exit 1
        ;;
esac

PASSWORD_REUSE_POLICY=$($DB_CMD "$QUERY")

if [ -z "$PASSWORD_REUSE_POLICY" ]; then
    WARN "비밀번호 재사용 방지 설정이 구성되어 있지 않습니다."
else
    PASSWORD_HISTORY=$(echo $PASSWORD_REUSE_POLICY | awk '{ print $1 }')
    if [[ "$DB_TYPE" == "MySQL" && "$PASSWORD_HISTORY" -ge 1 ]]; then
        OK "MySQL 비밀번호 재사용 방지가 $PASSWORD_HISTORY의 기록으로 올바르게 설정되어 있습니다."
    elif [[ "$DB_TYPE" == "PostgreSQL" ]]; then
        OK "PostgreSQL 비밀번호 재사용 방지 정책 확인 필요."
    else
        WARN "비밀번호 재사용 방지 설정은 있으나 $PASSWORD_HISTORY 기록으로는 충분하지 않습니다."
    fi
fi

cat "$result"

echo ; echo
