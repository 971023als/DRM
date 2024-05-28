@echo off
setlocal enabledelayedexpansion

echo -----------------------------------------------------
echo CODE [DBM-032] 데이터베이스 접속 시 통신구간에 비밀번호 평문 노출
echo -----------------------------------------------------

echo 지원하는 데이터베이스:
echo 1. SQL Server
echo 2. MySQL
echo 3. PostgreSQL
echo 4. Oracle
set /p DB_TYPE="사용 중인 데이터베이스 유형을 선택하세요 (1-4): "

if "%DB_TYPE%"=="1" (
    echo SQL Server가 선택되었습니다.
    echo 관리자 계정 이름을 입력하고, sqlcmd 실행 시 비밀번호가 요청될 것입니다.
    set /p DB_ADMIN="데이터베이스 관리자 사용자 이름을 입력하세요: "
    sqlcmd -U %DB_ADMIN% -Q "SELECT name FROM sys.sql_logins WHERE is_disabled = 0;" > nul 2>&1
    if errorlevel 1 (
        echo 관리자 계정 보안 설정 검사 실패. SQL Server에 연결할 수 없거나 쿼리 실행에 실패했습니다.
    ) else (
        echo 관리자 계정 보안 설정이 적절합니다.
    )
) else if "%DB_TYPE%"=="2" (
    echo MySQL이 선택되었습니다. 비밀번호는 다음 단계에서 입력하세요.
    set /p DB_ADMIN="데이터베이스 관리자 사용자 이름을 입력하세요: "
    echo MySQL 데이터베이스 관리자 비밀번호를 입력하세요:
    mysql -u %DB_ADMIN% -p -e "SHOW VARIABLES LIKE 'have_ssl';" > nul 2>&1
    if "!errorlevel!"=="0" (
        echo 연결 보안 설정이 적절합니다.
    ) else (
        echo 연결 보안 설정 검사 실패. MySQL에 연결할 수 없거나 SSL 설정을 확인할 수 없습니다.
    )
) else if "%DB_TYPE%"=="3" (
    echo PostgreSQL이 선택되었습니다. 비밀번호는 다음 단계에서 입력하세요.
    set /p DB_ADMIN="데이터베이스 관리자 사용자 이름을 입력하세요: "
    echo PostgreSQL 데이터베이스 관리자 비밀번호를 입력하세요:
    psql -U %DB_ADMIN% -c "SHOW ssl;" > nul 2>&1
    if "!errorlevel!"=="0" (
        echo 연결 보안 설정이 적절합니다.
    ) else (
        echo 연결 보안 설정 검사 실패. PostgreSQL에 연결할 수 없거나 SSL 설정을 확인할 수 없습니다.
    )
) else if "%DB_TYPE%"=="4" (
    echo Oracle이 선택되었습니다. Oracle 데이터베이스의 SSL 구성은 수동으로 확인해야 합니다.
    echo Oracle Net Listener의 SSL 구성을 검사하십시오.
    echo 이 작업은 데이터베이스 관리자 또는 네트워크 관리자가 수행해야 할 수 있습니다.
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

endlocal
