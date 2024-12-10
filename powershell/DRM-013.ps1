@echo off
setlocal

echo ============================================
echo CODE [DBM-013] 원격 접속에 대한 접근 제어 미흡
echo ============================================

set /p DB_TYPE="지원하는 데이터베이스: 1. MySQL, 2. PostgreSQL, 3. MSSQL. 사용 중인 데이터베이스 유형을 선택하세요 (1-3): "

if "%DB_TYPE%"=="1" (
    set /p MYSQL_USER="MySQL 사용자 이름을 입력하세요: "
    echo MySQL에서 원격 접근 사용자 확인:
    echo 다음 SQL 쿼리를 MySQL 클라이언트에서 실행하세요:
    echo SELECT host, user FROM mysql.user WHERE host NOT IN ('localhost', '127.0.0.1', '::1');
    echo.
) else if "%DB_TYPE%"=="2" (
    set /p PG_HBA="pg_hba.conf 파일의 경로를 입력하세요: "
    echo pg_hba.conf 파일에서 원격 접근을 허용하는 항목을 확인하세요.
    echo 제공된 경로: %PG_HBA%
    echo.
) else if "%DB_TYPE%"=="3" (
    echo MSSQL에서 원격 접근 사용자 확인:
    echo 다음 T-SQL 쿼리를 SQL Server Management Studio 또는 sqlcmd에서 실행하세요:
    echo SELECT name FROM sys.server_principals WHERE type_desc IN ('SQL_LOGIN', 'WINDOWS_LOGIN') AND is_disabled = 0;
    echo 원격으로 연결이 가능한 로그인만 고려하세요. MSSQL 서버의 네트워크 구성과 방화벽 설정도 검토해야 합니다.
    echo.
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
    goto end
)

echo 참고: 이 스크립트는 원격 접근 설정을 확인하는 방법에 대한 안내를 제공합니다.
echo 실제 확인은 수동으로 또는 적절한 데이터베이스 관리 도구를 사용하여 수행해야 합니다.

:end
echo ============================================
pause
