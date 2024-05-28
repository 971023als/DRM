@echo off
setlocal enabledelayedexpansion

echo ============================================
echo CODE [DBM-001] 취약하게 설정된 비밀번호 존재
echo ============================================
echo [양호]: 모든 데이터베이스 계정의 비밀번호가 강력한 경우
echo [취약]: 하나 이상의 데이터베이스 계정에 취약한 비밀번호가 설정된 경우
echo ============================================

echo 지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle 4. MSSQL
set /p DB_TYPE="사용 중인 데이터베이스 유형을 입력하세요: "

if "%DB_TYPE%"=="1" (
    set /p DB_USER="MySQL 사용자 이름을 입력하세요: "
    set /p DB_PASS="MySQL 비밀번호를 입력하세요: "
    mysql -u %DB_USER% -p%DB_PASS% -e "SELECT user, authentication_string FROM mysql.user;"
    echo 비밀번호 강도 검사가 필요합니다.
) else if "%DB_TYPE%"=="2" (
    set /p DB_USER="PostgreSQL 사용자 이름을 입력하세요: "
    set /p DB_PASS="PostgreSQL 비밀번호를 입력하세요: "
    psql -U %DB_USER% -W %DB_PASS% -c "SELECT usename AS user, passwd AS pass FROM pg_shadow;"
    echo 비밀번호 강도 검사가 필요합니다.
) else if "%DB_TYPE%"=="3" (
    echo Oracle 데이터베이스에 대한 수동 비밀번호 강도 검사가 필요합니다.
) else if "%DB_TYPE%"=="4" (
    echo MSSQL 데이터베이스에 대한 비밀번호 강도 검사는 주로 정책 설정을 통해 관리됩니다.
    set /p DB_USER="MSSQL 사용자 이름을 입력하세요: "
    set /p DB_PASS="MSSQL 비밀번호를 입력하세요: "
    sqlcmd -U %DB_USER% -P %DB_PASS% -Q "SELECT name FROM sys.sql_logins WHERE type_desc = 'SQL_LOGIN' AND is_disabled = 0;"
    echo MSSQL에서 SQL 로그인의 존재를 확인했습니다. 비밀번호 정책을 수동으로 검토하세요.
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
    goto end
)

:end
pause
