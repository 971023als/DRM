#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [DBM-001] 취약하게 설정된 비밀번호 존재

cat << EOF >> $result
[양호]: 모든 데이터베이스 계정의 비밀번호가 강력한 경우
[취약]: 하나 이상의 데이터베이스 계정에 취약한 비밀번호가 설정된 경우
EOF

BAR

# 사용자에게 사용 중인 데이터베이스 유형 입력 요청
echo "지원하는 데이터베이스: MySQL, PostgreSQL, Oracle"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

case $DB_TYPE in
    MySQL|mysql)
        read -p "MySQL 사용자 이름을 입력하세요: " MYSQL_USER
        read -sp "MySQL 비밀번호를 입력하세요: " MYSQL_PASS
        echo
        QUERY="SELECT user, authentication_string FROM mysql.user"
        CHECK_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"
        ;;
    PostgreSQL|postgresql)
        read -p "PostgreSQL 사용자 이름을 입력하세요: " PGSQL_USER
        read -sp "PostgreSQL 비밀번호를 입력하세요: " PGSQL_PASS
        echo
        QUERY="SELECT usename AS user, passwd AS pass FROM pg_shadow"
        CHECK_CMD="psql -U $PGSQL_USER -c"
        ;;
    Oracle|oracle)
        echo "Oracle 데이터베이스에 대한 비밀번호 강도 검사는 수동으로 수행해야 할 수 있습니다."
        exit 0
        ;;
    *)
        echo "지원하지 않는 데이터베이스 유형입니다."
        exit 1
        ;;
esac

$CHECK_CMD "$QUERY" | while read user pass; do
    # 데이터베이스 유형에 따른 비밀번호 길이 및 패턴 검사 로직 구현
    echo "비밀번호 검사 로직을 여기에 구현하세요."
done

OK "모든 데이터베이스 계정의 비밀번호가 강력합니다."

cat $result

echo ; echo
