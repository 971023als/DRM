#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [DBM-006] 로그인 실패 횟수에 따른 접속 제한 설정 미흡

cat << EOF >> $result
[양호]: 로그인 실패 횟수에 따른 접속 제한이 설정되어 있는 경우
[취약]: 로그인 실패 횟수에 따른 접속 제한이 설정되어 있지 않은 경우
EOF

BAR

echo "지원하는 데이터베이스: MySQL, PostgreSQL"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

case $DB_TYPE in
    MySQL|mysql)
        read -p "MySQL 사용자 이름을 입력하세요: " MYSQL_USER
        read -sp "MySQL 비밀번호를 입력하세요: " MYSQL_PASS
        echo
        MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"
        FAILURE_LIMIT_SETTING=$($MYSQL_CMD "SHOW VARIABLES LIKE 'login_failure_limit';")
        ;;
    PostgreSQL|postgresql)
        read -p "PostgreSQL 사용자 이름을 입력하세요: " PGSQL_USER
        read -sp "PostgreSQL 비밀번호를 입력하세요: " PGSQL_PASS
        echo
        # PostgreSQL은 기본적으로 로그인 실패 제한 설정을 데이터베이스 엔진 레벨에서 지원하지 않음
        echo "PostgreSQL은 기본적으로 로그인 실패 횟수에 따른 접속 제한을 지원하지 않습니다."
        echo "pg_hba.conf 파일을 통해 접근 제어를 설정하거나, 외부 보안 도구를 사용해야 합니다."
        FAILURE_LIMIT_SETTING="N/A"
        ;;
    *)
        echo "지원하지 않는 데이터베이스 유형입니다."
        exit 1
        ;;
esac

if [ "$DB_TYPE" == "MySQL" ]; then
    if [ -z "$FAILURE_LIMIT_SETTING" ]; then
        WARN "로그인 실패 횟수에 따른 접속 제한이 설정되어 있지 않습니다."
    else
        OK "로그인 실패 횟수에 따른 접속 제한이 설정되어 있습니다."
    fi
elif [ "$DB_TYPE" == "PostgreSQL" ]; then
    # PostgreSQL에 대한 추가 조치 안내
    WARN "PostgreSQL 사용 시 로그인 실패 횟수 제한을 위한 외부 조치가 필요합니다."
fi

cat $result

echo ; echo
