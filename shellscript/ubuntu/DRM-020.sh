#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR

CODE [DBM-020] 사용자별 계정 분리 미흡

cat << EOF >> "$result"
[양호]: 사용자별 계정 분리가 올바르게 설정된 경우
[취약]: 사용자별 계정 분리가 충분하지 않은 경우
EOF

BAR

echo "지원하는 데이터베이스: MySQL, PostgreSQL"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

read -p "데이터베이스 관리자 사용자 이름을 입력하세요: " DB_USER
read -sp "데이터베이스 관리자 비밀번호를 입력하세요: " DB_PASS
echo

case $DB_TYPE in
    MySQL|mysql)
        DB_CMD="mysql -u $DB_USER -p$DB_PASS -Bse"
        QUERY="SELECT User, Host, Db, Select_priv, Insert_priv, Update_priv FROM mysql.db;"
        ;;
    PostgreSQL|postgresql)
        DB_CMD="psql -U $DB_USER -c"
        QUERY="SELECT rolname, rolselectpriv, rolinsertpriv, rolupdatepriv FROM pg_roles JOIN pg_database ON (rolname = datname);"
        # PostgreSQL의 실제 권한 확인 쿼리는 상황에 따라 다를 수 있습니다.
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

USER_PRIVILEGES=$(echo "$QUERY" | $DB_CMD)

# 사용자 권한 검사 로직 (MySQL과 PostgreSQL에 따라 다를 수 있음)
echo "$USER_PRIVILEGES" | while read USER PRIVILEGES; do
    # 사용자별 권한 검사 로직 구현
    echo "사용자 $USER 권한 검사 결과: $PRIVILEGES"
done

cat "$result"

echo ; echo
