@echo off
setlocal EnableDelayedExpansion

echo ============================================
echo CODE [DBM-007] 비밀번호의 복잡도 정책 설정 미흡
echo ============================================
echo [양호]: 모든 사용자의 비밀번호 복잡도 정책이 적절하게 설정되어 있는 경우
echo [취약]: 하나 이상의 사용자의 비밀번호 복잡도 정책이 설정되어 있지 않은 경우
echo ============================================

echo 지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. MSSQL
set /p DB_TYPE="사용 중인 데이터베이스 유형을 입력하세요: "

if "%DB_TYPE%"=="1" (
    set /p MYSQL_USER="MySQL 사용자 이름을 입력하세요: "
    set /p MYSQL_PASS="MySQL 비밀번호를 입력하세요: "
    echo MySQL에서 비밀번호 복잡도 정책을 확인합니다...
    mysql -u %MYSQL_USER% -p%MYSQL_PASS% -e "SELECT PLUGIN FROM mysql.user WHERE User='root';" > password_policy.txt

    findstr /C:"mysql_native_password" password_policy.txt > nul
    if errorlevel 1 (
        echo [양호]: 비밀번호 복잡도 정책이 적절하게 설정되어 있습니다.
    ) else (
        echo [취약]: 하나 이상의 사용자의 비밀번호 복잡도 정책이 설정되어 있지 않습니다.
    )

    del password_policy.txt
) else if "%DB_TYPE%"=="2" (
    set /p PGSQL_USER="PostgreSQL 사용자 이름을 입력하세요: "
    set /p PGSQL_PASS="PostgreSQL 비밀번호를 입력하세요: "
    echo PostgreSQL에서 비밀번호 복잡도 정책을 확인하는 것은 직접 수행되어야 합니다.
    echo 암호화 정책은 pg_hba.conf 파일 또는 데이터베이스 설정을 통해 확인하세요.
) else if "%DB_TYPE%"=="3" (
    set /p MSSQL_USER="MSSQL 사용자 이름을 입력하세요: "
    set /p MSSQL_PASS="MSSQL 비밀번호를 입력하세요: "
    echo MSSQL에서 비밀번호 복잡도 정책을 확인 중...
    sqlcmd -U %MSSQL_USER% -P %MSSQL_PASS% -Q "SELECT name, is_policy_checked, is_expiration_checked FROM sys.sql_logins WHERE type_desc = 'SQL_LOGIN';" > password_policy.txt
    findstr /C:"1" password_policy.txt > nul
    if errorlevel 1 (
        echo [취약]: 하나 이상의 사용자의 비밀번호 복잡도 정책이 설정되어 있지 않습니다.
    ) else (
        echo [양호]: 모든 SQL 로그인에 대한 비밀번호 복잡도 정책이 적절하게 설정되어 있습니다.
    )
    del password_policy.txt
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

:end
pause
