@echo off
setlocal

echo ============================================
echo CODE [DBM-016] 최신 보안패치와 벤더 권고사항 미적용
echo ============================================
echo [양호]: 최신 보안 패치와 벤더 권고사항이 적용된 경우
echo [취약]: 최신 보안 패치와 벤더 권고사항이 적용되지 않은 경우
echo ============================================

echo 지원하는 데이터베이스: MySQL, PostgreSQL, Oracle, MSSQL
set /p DB_TYPE="사용 중인 데이터베이스 유형을 입력하세요: "

if "%DB_TYPE%"=="MySQL" (
    for /f "tokens=*" %%i in ('mysql --version') do set VERSION=%%i
    set "VERSION=%VERSION:*is =%"
) else if "%DB_TYPE%"=="PostgreSQL" (
    for /f "tokens=*" %%i in ('psql -V') do set VERSION=%%i
    set "VERSION=%VERSION:* =%"
) else if "%DB_TYPE%"=="Oracle" (
    for /f "tokens=*" %%i in ('sqlplus -v') do set VERSION=%%i
    set "VERSION=%VERSION:*Release =%"
    set "VERSION=%VERSION:*,=%"
) else if "%DB_TYPE%"=="MSSQL" (
    for /f "tokens=*" %%i in ('sqlcmd -Q "SELECT @@VERSION" -h -1') do set VERSION=%%i
    set "VERSION=%VERSION:*Server =%"
    set "VERSION=%VERSION:*,=%"
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
    goto end
)

echo 현재 %DB_TYPE% 버전: %VERSION%
echo.
echo %DB_TYPE% 버전 %VERSION%에 대한 보안 패치와 권고사항을 수동으로 확인하세요.
echo CVE 데이터베이스 조회, 데이터베이스 벤더의 보안 공지 페이지 확인 등을 포함할 수 있습니다.
echo.

:end
pause
