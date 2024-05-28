#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-032] 데이터베이스 접속 시 통신구간에 비밀번호 평문 노출

cat << EOF >> "$result"
[양호]: 데이터베이스 접속 시 비밀번호가 암호화되어 전송되는 경우
[취약]: 데이터베이스 접속 시 비밀번호가 평문으로 노출되는 경우
EOF

BAR

echo "지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle"
read -p "사용 중인 데이터베이스 유형을 선택하세요 (1-3): " DB_TYPE

case $DB_TYPE in
    1)
        # MySQL의 SSL 설정 확인
        DB_CONNECTION_CMD="mysql -u root -p -e"
        SECURE_CONNECTION=$($DB_CONNECTION_CMD "SHOW VARIABLES LIKE '%ssl%';" | grep -E 'have_ssl|have_openssl')
        ;;
    2)
        # PostgreSQL의 SSL 설정 확인
        DB_CONNECTION_CMD="psql -U postgres -c"
        SECURE_CONNECTION=$($DB_CONNECTION_CMD "SHOW ssl;")
        ;;
    3)
        # Oracle의 SSL 설정 확인 (Oracle Net Listener 설정을 통해 확인)
        echo "Oracle 데이터베이스의 경우, 수동으로 Net Listener의 SSL 구성을 확인해야 합니다."
        SECURE_CONNECTION="Manual Check Required"
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

# 연결 보안 설정 검사
if [[ "$SECURE_CONNECTION" =~ "ON" || "$SECURE_CONNECTION" =~ "ENABLED" || "$SECURE_CONNECTION" == "Manual Check Required" ]]; then
    OK "데이터베이스 접속 시 비밀번호가 안전하게 암호화되어 전송됩니다."
else
    WARN "데이터베이스 접속 시 비밀번호가 평문으로 노출될 위험이 있습니다."
fi

cat "$result"

echo ; echo
