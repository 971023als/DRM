@echo off
setlocal EnableDelayedExpansion

echo ============================================
echo CODE [DBM-025] 서비스 지원이 종료된(EoS) 데이터베이스 사용 확인
echo ============================================
echo [양호]: 현재 사용 중인 데이터베이스 버전이 지원되는 경우
echo [취약]: 현재 사용 중인 데이터베이스 버전이 서비스 지원 종료(EoS) 상태인 경우
echo ============================================

echo 지원하는 데이터베이스: 
echo 1. MySQL 
echo 2. PostgreSQL 
echo 3. Oracle
echo 4. MSSQL
echo.

set /p DBType="데이터베이스 유형 번호를 입력하세요: "
set /p DBUser="데이터베이스 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 비밀번호를 입력하세요: "

if "%DBType%"=="1" (
    echo MySQL 버전 확인 중...
    mysql -u %DBUser% -p%DBPass% -e "SELECT VERSION();" > temp.txt
    set /p MYSQL_VERSION=<temp.txt
    del temp.txt
    echo 현재 MySQL 버전: !MYSQL_VERSION!
    REM MySQL EoS 버전에 대한 실제 확인 로직 추가 필요
    echo MySQL EoS 버전 리스트와 비교하세요.
) else if "%DBType%"=="2" (
    echo PostgreSQL 버전 확인 중...
    psql -U %DBUser% -c "SELECT version();" > temp.txt
    for /f "tokens=3" %%i in ('findstr "PostgreSQL" temp.txt') do set PGSQL_VERSION=%%i
    del temp.txt
    echo 현재 PostgreSQL 버전: !PGSQL_VERSION!
    REM PostgreSQL EoS 버전에 대한 실제 확인 로직 추가 필요
    echo PostgreSQL EoS 버전 리스트와 비교하세요.
) else if "%DBType%"=="3" (
    echo Oracle 데이터베이스 버전 확인은 SQL*Plus 또는 Oracle SQL Developer를 사용하여 수동으로 확인하세요.
    echo 예: SELECT * FROM v$version;
) else if "%DBType%"=="4" (
    echo MSSQL 버전 확인 중...
    sqlcmd -U %DBUser% -P %DBPass% -Q "SELECT @@VERSION;" > temp.txt
    for /f "delims=" %%i in ('type temp.txt') do set MSSQL_VERSION=%%i
    del temp.txt
    echo 현재 MSSQL 버전: !MSSQL_VERSION!
    REM MSSQL EoS 버전에 대한 실제 확인 로직 추가 필요
    echo MSSQL EoS 버전 리스트와 비교하세요.
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
)

:end
echo ============================================
pause
