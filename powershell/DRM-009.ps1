@echo off
setlocal

echo ============================================
echo CODE [DBM-009] 사용되지 않는 세션 종료 미흡
echo ============================================

echo 지원하는 데이터베이스: 
echo 1. MySQL
echo 2. PostgreSQL
echo 3. MSSQL
set /p DB_TYPE="데이터베이스 유형을 선택하세요 (1-3): "

if "%DB_TYPE%"=="1" (
    set /p MYSQL_USER="Enter MySQL username: "
    set /p MYSQL_PASS="Enter MySQL password: "
    echo Checking session timeout settings for MySQL...
    mysql -u%MYSQL_USER% -p%MYSQL_PASS% -Bse "SHOW VARIABLES LIKE 'wait_timeout';"
) else if "%DB_TYPE%"=="2" (
    set /p PGSQL_USER="Enter PostgreSQL username: "
    set /p PGSQL_PASS="Enter PostgreSQL password: "
    echo Checking session timeout settings for PostgreSQL...
    psql -U %PGSQL_USER% -w%PGSQL_PASS% -t -c "SHOW idle_in_transaction_session_timeout;"
) else if "%DB_TYPE%"=="3" (
    set /p MSSQL_USER="Enter MSSQL username: "
    set /p MSSQL_PASS="Enter MSSQL password: "
    echo Checking session timeout settings for MSSQL...
    sqlcmd -U %MSSQL_USER% -P %MSSQL_PASS% -Q "SELECT value_in_use FROM sys.configurations WHERE name = 'remote query timeout';"
) else (
    echo Unsupported database type.
    goto end
)

:end
echo ============================================
pause
