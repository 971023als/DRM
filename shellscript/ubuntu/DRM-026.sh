#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-026] 데이터베이스 구동 계정의 umask 설정 확인

cat << EOF >> "$result"
[양호]: 적절한 umask 설정이 적용된 경우
[취약]: umask 설정이 미흡한 경우
EOF

BAR

echo "지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle"
read -p "사용 중인 데이터베이스 유형을 선택하세요 (1-3): " DB_TYPE

# 데이터베이스 서비스를 실행하는 사용자 계정 설정
case $DB_TYPE in
    1)
        DATABASE_USER='mysql'
        ;;
    2)
        DATABASE_USER='postgres'
        ;;
    3)
        DATABASE_USER='oracle'
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

# 데이터베이스 서비스를 실행하는 사용자 계정에 대한 umask 값 확인
UMASK_VALUE=$(su - $DATABASE_USER -c umask)

# 적절한 umask 값이 설정되었는지 확인 (예: 027)
EXPECTED_UMASK='027'
if [ "$UMASK_VALUE" == "$EXPECTED_UMASK" ]; then
    OK "데이터베이스 구동 계정($DATABASE_USER)에 적절한 umask 값($EXPECTED_UMASK)이 설정되어 있습니다."
else
    WARN "데이터베이스 구동 계정($DATABASE_USER)의 umask 값($UMASK_VALUE)이 기대치($EXPECTED_UMASK)와 다릅니다."
fi

cat "$result"

echo ; echo
