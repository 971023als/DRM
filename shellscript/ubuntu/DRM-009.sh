#!/bin/bash

. function.sh

TMP1=$(mktemp /tmp/$(basename $0).XXXXXX)

BAR

CODE [DBM-009] 사용되지 않는 세션 종료 미흡

cat << EOF >> $result
[양호]: 사용되지 않는 데이터베이스 세션의 종료 시간이 적절히 설정되어 있는 경우
[취약]: 사용되지 않는 데이터베이스 세션의 종료 시간이 설정되어 있지 않은 경우
EOF

BAR

echo "지원하는 데이터베이스: MySQL, PostgreSQL"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

case $DB_TYPE in
    MySQL|mysql)
        read -p "Enter MySQL username: " MYSQL_USER
        read -sp "Enter MySQL password: " MYSQL_PASS
        echo
        MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"
        QUERY="SHOW VARIABLES LIKE 'wait_timeout';"
        ;;
    PostgreSQL|postgresql)
        read -p "Enter PostgreSQL username: " PGSQL_USER
        read -sp "Enter PostgreSQL password: " PGSQL_PASS
        echo
        PGSQL_CMD="psql -U $PGSQL_USER -c"
        QUERY="SHOW idle_in_transaction_session_timeout;"
        ;;
    *)
        echo "Unsupported database type."
        rm $TMP1
        exit 1
        ;;
esac

if [[ $DB_TYPE == "MySQL" || $DB_TYPE == "mysql" ]]; then
    SESSION_TIMEOUT=$($MYSQL_CMD "$QUERY")
elif [[ $DB_TYPE == "PostgreSQL" || $DB_TYPE == "postgresql" ]]; then
    SESSION_TIMEOUT=$($PGSQL_CMD "$QUERY")
fi

if [[ -z "$SESSION_TIMEOUT" ]]; then
    WARN "세션 종료 시간이 설정되어 있지 않습니다."
else
    TIMEOUT_VALUE=$(echo $SESSION_TIMEOUT | awk '{print $2}')
    if [[ "$TIMEOUT_VALUE" -le 300 ]]; then
        OK "세션 종료 시간이 적절히 설정되어 있습니다: $TIMEOUT_VALUE seconds."
    else
        WARN "세션 종료 시간이 너무 길게 설정되어 있습니다: $TIMEOUT_VALUE seconds."
    fi
fi

cat $result

rm $TMP1

echo
