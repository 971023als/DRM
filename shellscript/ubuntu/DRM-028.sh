#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-028] 업무상 불필요한 데이터베이스 오브젝트 존재 여부 확인

cat << EOF >> "$result"
[양호]: 불필요한 데이터베이스 오브젝트가 존재하지 않는 경우
[취약]: 불필요한 데이터베이스 오브젝트가 존재하는 경우
EOF

BAR

echo "지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle"
read -p "사용 중인 데이터베이스 유형을 선택하세요 (1-3): " DB_TYPE

read -p "데이터베이스 사용자 이름을 입력하세요: " DB_USER
read -sp "데이터베이스 비밀번호를 입력하세요: " DB_PASS
echo

case $DB_TYPE in
    1)
        DB_CMD="mysql -u $DB_USER -p$DB_PASS -Bse"
        QUERY="SHOW TABLES;"
        ;;
    2)
        DB_CMD="psql -U $DB_USER -c"
        QUERY="\dt"
        ;;
    3)
        DB_CMD="sqlplus -s $DB_USER/$DB_PASS"
        QUERY="SELECT table_name FROM user_tables;"
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

# 데이터베이스 오브젝트 리스트 가져오기
DB_OBJECTS=$(echo "$QUERY" | $DB_CMD)

# 불필요한 오브젝트 확인 로직 구현
# 이 부분은 데이터베이스와 업무 요구 사항에 따라 다를 수 있으며, 
# 불필요한 오브젝트를 식별하는 구체적인 조건이 필요합니다.
echo "$DB_OBJECTS" | while read OBJECT; do
    # 여기에 불필요한 오브젝트를 식별하는 로직 추가
    echo "오브젝트 확인: $OBJECT"
done

cat "$result"

echo ; echo
