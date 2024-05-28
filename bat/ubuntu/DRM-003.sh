@echo off
setlocal

echo ============================================
echo CODE [DBM-003] 업무상 불필요한 계정 존재
echo ============================================
echo [양호]: 업무상 불필요한 데이터베이스 계정이 존재하지 않는 경우
echo [취약]: 업무상 불필요한 데이터베이스 계정이 존재하는 경우
echo ============================================

echo 지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. MSSQL
set /p DB_TYPE="사용 중인 데이터베이스 유형을 입력하세요: "

if "%DB_TYPE%"=="1" (
    set /p DB_USER="MySQL 사용자 이름을 입력하세요: "
    set /p DB_PASS="MySQL 비밀번호를 입력하세요: "
    echo 불필요한 MySQL 계정을 확인 중...
    mysql -u%DB_USER% -p%DB_PASS% -e "SELECT User, Host FROM mysql.user WHERE User NOT IN ('root', 'mysql.sys', 'mysql.session');"
) else if "%DB_TYPE%"=="2" (
    set /p DB_USER="PostgreSQL 사용자 이름을 입력하세요: "
    set /p DB_PASS="PostgreSQL 비밀번호를 입력하세요: "
    echo 불필요한 PostgreSQL 계정을 확인 중...
    psql -U %DB_USER% -w %DB_PASS% -c "SELECT usename FROM pg_shadow WHERE usename NOT IN ('postgres');"
) else if "%DB_TYPE%"=="3" (
    set /p DB_USER="MSSQL 사용자 이름을 입력하세요: "
    set /p DB_PASS="MSSQL 비밀번호를 입력하세요: "
    echo 불필요한 MSSQL 계정을 확인 중...
    sqlcmd -U %DB_USER% -P %DB_PASS% -Q "SELECT name FROM sys.syslogins WHERE name NOT IN ('sa') AND type = 'S';"
    echo MSSQL 데이터베이스 계정 목록을 검토하세요.
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
    goto :eof
)

echo 확인 완료. 불필요한 계정 목록을 검토하세요.

:end
pause
