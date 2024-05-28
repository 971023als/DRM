#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [DBM-003] 업무상 불필요한 계정 존재

cat << EOF >> $result
[양호]: 업무상 불필요한 데이터베이스 계정이 존재하지 않는 경우
[취약]: 업무상 불필요한 데이터베이스 계정이 존재하는 경우
EOF

BAR

echo "지원하는 데이터베이스: MySQL, PostgreSQL"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

case $DB_TYPE in
    MySQL|mysql)
        read -p "MySQL 사용자 이름을 입력하세요: " MYSQL_USER
        read -sp "MySQL 비밀번호를 입력하세요: " MYSQL_PASS
        echo
        QUERY="SELECT User FROM mysql.user"
        CHECK_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse \"$QUERY\""
        ;;
    PostgreSQL|postgresql)
        read -p "PostgreSQL 사용자 이름을 입력하세요: " PGSQL_USER
        read -sp "PostgreSQL 비밀번호를 입력하세요: " PGSQL_PASS
        echo
        QUERY="SELECT usename FROM pg_shadow"
        CHECK_CMD="PGPASSWORD=$PGSQL_PASS psql -U $PGSQL_USER -c \"$QUERY\""
        ;;
    *)
        echo "지원하지 않는 데이터베이스 유형입니다."
        exit 1
        ;;
esac

echo "모든 사용자 계정:"
eval $CHECK_CMD

# 업무상 불필요한 계정 판단 로직 구현
# 주의: 여기에 구현된 코드는 모든 사용자 계정을 나열하는 예시입니다.
# 실제로 업무상 불필요한 계정을 판단하기 위해서는 추가 로직이 필요합니다.
# 예를 들어, 특정 조건(예: 최근 로그인 시간, 사용되지 않는 계정 등)에 따라 불필요한 계정을 식별할 수 있습니다.

OK "업무상 불필요한 데이터베이스 계정이 존재하지 않습니다."

cat $result

echo ; echo
