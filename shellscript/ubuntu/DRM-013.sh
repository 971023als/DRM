#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [DBM-013] 원격 접속에 대한 접근 제어 미흡

cat << EOF >> $result
[양호]: 원격 접속 제어가 적절히 설정되어 있는 경우
[취약]: 원격 접속 제어가 미흡한 경우
EOF

BAR

echo "지원하는 데이터베이스: MySQL, PostgreSQL"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

case $DB_TYPE in
    MySQL|mysql)
        read -p "Enter MySQL username: " MYSQL_USER
        read -sp "Enter MySQL password: " MYSQL_PASS
        echo
        MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -e"
        $MYSQL_CMD "SELECT host, user FROM mysql.user WHERE host NOT IN ('localhost', '127.0.0.1', '::1');" | while read host user; do
          if [ ! -z "$user" ]; then
            WARN "원격 호스트($host)에서 접근 가능한 사용자가 있습니다: $user"
          fi
        done
        ;;
    PostgreSQL|postgresql)
        read -p "Enter path to pg_hba.conf: " PG_HBA
        if [ -f "$PG_HBA" ] && grep -q "host" $PG_HBA; then
          WARN "pg_hba.conf 파일에 원격 호스트 접근을 허용하는 설정이 있습니다."
        else
          OK "pg_hba.conf 파일이 원격 접속을 제한하고 있습니다."
        fi
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

# Check network level access controls, such as iptables or firewalls
if sudo iptables -L -n | grep -q 'ACCEPT'; then
  WARN "iptables에 원격 접속을 허용하는 규칙이 있습니다."
else
  OK "iptables이 원격 접속을 제한하고 있습니다."
fi

cat $result

echo ; echo
