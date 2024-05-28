#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [DBM-007] 비밀번호의 복잡도 정책 설정 미흡

cat << EOF >> $result
[양호]: 모든 사용자의 비밀번호 복잡도 정책이 적절하게 설정되어 있는 경우
[취약]: 하나 이상의 사용자의 비밀번호 복잡도 정책이 설정되어 있지 않은 경우
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
        QUERY="SELECT user, host, authentication_string FROM mysql.user"
        ;;
    PostgreSQL|postgresql)
        read -p "PostgreSQL 사용자 이름을 입력하세요: " PGSQL_USER
        read -sp "PostgreSQL 비밀번호를 입력하세요: " PGSQL_PASS
        echo
        PGSQL_CMD="psql -U $PGSQL_USER -c"
        QUERY="SELECT usename AS user FROM pg_shadow"
        ;;
    *)
        echo "지원하지 않는 데이터베이스 유형입니다."
        exit 1
        ;;
esac

if [ "$DB_TYPE" = "MySQL" ] || [ "$DB_TYPE" = "mysql" ]; then
    $MYSQL_CMD "$QUERY" | while read user host authentication_string; do
        # MySQL 비밀번호 복잡도 검사 로직
    done
elif [ "$DB_TYPE" = "PostgreSQL" ] || [ "$DB_TYPE" = "postgresql" ]; then
    # PostgreSQL 비밀번호 복잡도 검사 로직
    echo "PostgreSQL에서는 pg_shadow 테이블의 암호화된 비밀번호를 직접 검사할 수 없습니다."
    echo "암호화 정책은 pg_hba.conf 파일 또는 데이터베이스 설정을 통해 강제될 수 있습니다."
    # PostgreSQL의 경우, 비밀번호 정책을 데이터베이스 설정으로 강제하는 예제
    PGSQL_SECURITY_SETTING=$($PGSQL_CMD "SHOW password_encryption;")
    if [[ "$PGSQL_SECURITY_SETTING" =~ "scram-sha-256" ]]; then
        OK "PostgreSQL이 scram-sha-256 비밀번호 암호화를 사용합니다."
    else
        WARN "PostgreSQL 비밀번호 암호화 정책이 미흡할 수 있습니다."
    fi
fi

cat $result

echo ; echo
