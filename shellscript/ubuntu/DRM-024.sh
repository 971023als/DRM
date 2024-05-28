#!/bin/bash

. function.sh

TMP1=$(mktemp)
> "$TMP1"

BAR
CODE [DBM-024] 불필요하게 'WITH GRANT OPTION' 옵션이 설정된 권한 확인

cat << EOF >> "$result"
[양호]: 'WITH GRANT OPTION'이 불필요하게 설정되지 않은 경우
[취약]: 'WITH GRANT OPTION'이 불필요하게 설정된 권한이 있는 경우
EOF

BAR

echo "지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle"
read -p "사용 중인 데이터베이스 유형을 선택하세요 (1-3): " DB_TYPE

read -p "데이터베이스 사용자 이름을 입력하세요: " DB_USER
read -sp "데이터베이스 비밀번호를 입력하세요: " DB_PASS
echo

case $DB_TYPE in
    1)
        # MySQL command
        DB_CMD="mysql -u $DB_USER -p$DB_PASS -Bse"
        QUERY="SELECT GRANTEE, PRIVILEGE_TYPE FROM information_schema.user_privileges WHERE IS_GRANTABLE = 'YES';"
        ;;
    2)
        # PostgreSQL command (PostgreSQL does not directly use WITH GRANT OPTION in the same way, this is a placeholder example)
        DB_CMD="psql -U $DB_USER -c"
        QUERY="SELECT grantee, privilege_type FROM information_schema.role_usage_grants WHERE is_grantable = 'YES';"
        ;;
    3)
        # Oracle command (Placeholder, as Oracle's system for privileges might require different handling)
        echo "Oracle support not implemented in this script."
        exit 1
        ;;
    *)
        echo "Unsupported database type."
        exit 1
        ;;
esac

# Check for unnecessary WITH GRANT OPTION privileges
GRANT_OPTION_PRIVILEGES=$(echo "$QUERY" | $DB_CMD)

# Check if any unnecessary privileges are found
if [ -n "$GRANT_OPTION_PRIVILEGES" ]; then
    WARN "The following privileges are granted with 'WITH GRANT OPTION' unnecessarily: $GRANT_OPTION_PRIVILEGES"
else
    OK "No unnecessary privileges are granted with 'WITH GRANT OPTION'."
fi

cat "$result"

echo ; echo
