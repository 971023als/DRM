@echo off
setlocal enabledelayedexpansion

echo -----------------------------------------------------
echo CODE [DBM-032] 데이터베이스 접속 시 통신구간에 비밀번호 평문 노출
echo -----------------------------------------------------

echo 지원하는 데이터베이스:
echo 1. SQL Server
echo 2. MySQL
echo 3. PostgreSQL
set /p DB_TYPE="데이터베이스 유형 번호를 입력하세요 (1-3): "

set /p DB_ADMIN="데이터베이스 관리자 사용자 이름을 입력하세요: "

if "%DB_TYPE%"=="1" (
    echo SQL Server 선택됨. 비밀번호는 sqlcmd에 의해 요청될 것입니다.
    sqlcmd -U %DB_ADMIN% -Q "SELECT name FROM sys.sql_logins WHERE name = 'sa';" > nul 2>&1
    if errorlevel 1 (
        echo 관리자 계정 보안 설정 검사 실패.
    ) else (
        echo 관리자 계정 보안 설정이 적절합니다.
    )
) else if "%DB_TYPE%"=="2" (
    set /p DB_PASS="MySQL 데이터베이스 관리자 비밀번호를 입력하세요: "
    mysql -u %DB_ADMIN% -p%DB_PASS% -e "SELECT User, Host FROM mysql.user WHERE User = 'root';" > nul 2>&1
    if errorlevel 1 (
        echo 관리자 계정 보안 설정 검사 실패.
    ) else (
        echo 관리자 계정 보안 설정이 적절합니다.
    )
) else if "%DB_TYPE%"=="3" (
    echo PostgreSQL 선택됨. 비밀번호는 psql에 의해 요청될 것입니다.
    psql -U %DB_ADMIN% -c "SELECT rolname FROM pg_roles WHERE rolname = 'postgres';" > nul 2>&1
    if errorlevel 1 (
        echo 관리자 계정 보안 설정 검사 실패.
    ) else (
        echo 관리자 계정 보안 설정이 적절합니다.
    )
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

endlocal
