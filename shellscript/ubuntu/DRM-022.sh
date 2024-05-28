#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-022] 데이터베이스 설정 파일의 접근 권한 설정 확인

cat << EOF >> "$result"
[양호]: 선택한 데이터베이스 설정 파일의 접근 권한이 적절한 경우
[취약]: 설정 파일의 접근 권한이 미흡한 경우
EOF

BAR

echo "지원하는 데이터베이스: 1. MySQL 2. Oracle 3. PostgreSQL"
read -p "사용 중인 데이터베이스 번호를 입력하세요: " DB_CHOICE

case $DB_CHOICE in
    1)
        FILES_TO_CHECK=("/etc/mysql/my.cnf")
        ;;
    2)
        FILES_TO_CHECK=("/u01/app/oracle/product/11.2.0/dbhome_1/network/admin/listener.ora")
        ;;
    3)
        FILES_TO_CHECK=("/var/lib/pgsql/data/postgresql.conf")
        ;;
    *)
        echo "잘못된 선택입니다."
        exit 1
        ;;
esac

# Check permissions for each file
for file in "${FILES_TO_CHECK[@]}"; do
    if [ -e "$file" ]; then
        PERMS=$(stat -c '%a' "$file")
        if [ "$PERMS" -gt "600" ]; then # Replace 600 with the desired permission level
            WARN "File $file has insecure permissions: $PERMS"
        else
            OK "File $file has secure permissions: $PERMS"
        fi
    else
        WARN "File $file does not exist"
    fi
done

cat "$result"

echo ; echo
