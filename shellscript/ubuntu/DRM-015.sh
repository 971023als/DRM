#!/bin/bash

. function.sh

TMP1=$(SCRIPTNAME).log
> $TMP1

BAR

CODE [DBM-015] Public Role에 불필요한 권한 존재

cat << EOF >> $result
[양호]: Public Role에 불필요한 권한이 부여되지 않은 경우
[취약]: Public Role에 불필요한 권한이 부여된 경우
EOF

BAR

echo "지원하는 데이터베이스: MySQL, Oracle"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

read -p "Enter database user name: " DB_USER
read -sp "Enter database password: " DB_PASS
echo

case $DB_TYPE in
    MySQL|mysql)
        DB_CMD="mysql"
        CHECK_QUERY="SELECT GRANTEE, PRIVILEGE_TYPE FROM information_schema.user_privileges WHERE GRANTEE = 'PUBLIC';"
        ;;
    Oracle|oracle)
        DB_CMD="sqlplus -s /nolog"
        CHECK_QUERY="conn $DB_USER/$DB_PASS\nSET HEADING OFF;\nSET FEEDBACK OFF;\nSELECT PRIVILEGE FROM dba_sys_privs WHERE GRANTEE = 'PUBLIC';\nEXIT;"
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

echo "Checking for unnecessary privileges granted to PUBLIC role..."

# Check for unnecessary PUBLIC role privileges
UNNECESSARY_PRIVILEGES=$(echo -e "$CHECK_QUERY" | $DB_CMD)

# Check if unnecessary privileges are granted
if [ -z "$UNNECESSARY_PRIVILEGES" ]; then
    OK "No unnecessary privileges granted to PUBLIC role."
else
    WARN "The following unnecessary privileges are granted to PUBLIC role: $UNNECESSARY_PRIVILEGES"
fi

cat $result

echo ; echo
