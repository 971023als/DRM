#!/bin/bash

# 함수 파일 source
. function.sh

# 임시 로그 파일 생성
TMP1=$(SCRIPTNAME).log
> $TMP1

# 로그 시작 구분선
BAR

# 주제 코드
CODE [DBM-008] 주기적인 비밀번호 변경 미흡

# 결과 내용을 결과 파일에 추가
cat << EOF >> $result
[양호]: 주기적인 비밀번호 변경 정책이 적절하게 설정되어 있는 경우
[취약]: 주기적인 비밀번호 변경 정책이 설정되어 있지 않은 경우
EOF

# 로그 끝 구분선
BAR

echo "지원하는 데이터베이스: MySQL, PostgreSQL"
read -p "사용 중인 데이터베이스 유형을 입력하세요: " DB_TYPE

case $DB_TYPE in
    MySQL|mysql)
        read -p "MySQL 사용자 이름을 입력하세요: " MYSQL_USER
        read -sp "MySQL 비밀번호를 입력하세요: " MYSQL_PASS
        echo
        MYSQL_CMD="mysql -u $MYSQL_USER -p$MYSQL_PASS -Bse"
        QUERY="SELECT user, password_last_changed FROM mysql.user;"
        ;;
    PostgreSQL|postgresql)
        # PostgreSQL에 대한 접속 정보 입력 요청 및 처리 방법
        read -p "PostgreSQL 사용자 이름을 입력하세요: " PGSQL_USER
        read -sp "PostgreSQL 비밀번호를 입력하세요: " PGSQL_PASS
        echo
        PGSQL_CMD="psql -U $PGSQL_USER -c"
        QUERY="SELECT usename as user, rolpassword as password_last_changed FROM pg_shadow;"
        ;;
    *)
        echo "지원하지 않는 데이터베이스 유형입니다."
        exit 1
        ;;
esac

# 주기적인 비밀번호 변경 정책 설정 확인
if [[ $DB_TYPE == "MySQL" || $DB_TYPE == "mysql" ]]; then
    PASSWORD_CHANGE_POLICY=$($MYSQL_CMD "$QUERY")
elif [[ $DB_TYPE == "PostgreSQL" || $DB_TYPE == "postgresql" ]]; then
    PASSWORD_CHANGE_POLICY=$($PGSQL_CMD "$QUERY")
fi

# 비밀번호 변경 정책 확인
if [ -z "$PASSWORD_CHANGE_POLICY" ]; then
    WARN "주기적인 비밀번호 변경 정책이 설정되어 있지 않습니다."
else
    # 주기적인 변경 정책에 따라 결과를 필터링합니다.
    MAX_DAYS=90 # 여기서 X일을 정의합니다.
    CURRENT_DATE=$(date +%F)
    while read user last_changed; do
        if [[ $(date -d "$last_changed" +%F) < $(date -d "$CURRENT_DATE - $MAX_DAYS days" +%F) ]]; then
            WARN "주기적으로 비밀번호가 변경되지 않은 계정이 존재합니다: $user (마지막 변경: $last_changed)"
        fi
    done <<< "$PASSWORD_CHANGE_POLICY"
fi

# 결과 파일 출력
cat $result

# 종료 줄바꿈
echo ; echo
