@echo off
setlocal EnableDelayedExpansion

echo ============================================
echo CODE [DBM-030] Audit Table에 대한 접근 제어 미흡
echo ============================================
echo [양호]: Audit Table에 대한 접근 제어가 적절하게 설정된 경우
echo [취약]: Audit Table에 대한 접근 제어가 미흡한 경우
echo ============================================

echo 지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle 4. MSSQL
set /p DB_TYPE="데이터베이스 유형을 선택하세요 (1-4): "

set /p DB_USER="데이터베이스 사용자 이름을 입력하세요: "
set /p DB_PASS="데이터베이스 비밀번호를 입력하세요: "

if "%DB_TYPE%"=="1" (
    echo MySQL에서 Audit Table 접근 제어를 확인 중입니다...
    mysql -u %DB_USER% -p%DB_PASS% -e "SHOW GRANTS FOR 'audit_user';"
    echo 결과를 검토하여 Audit Table에 대한 접근 제어가 적절한지 확인하세요.
) else if "%DB_TYPE%"=="2" (
    echo PostgreSQL에서 Audit Table 접근 제어를 확인 중입니다...
    psql -U %DB_USER% -c "\dp audit_table;"
    echo 결과를 검토하여 Audit Table에 대한 접근 제어가 적절한지 확인하세요.
) else if "%DB_TYPE%"=="3" (
    echo Oracle에서 Audit Table 접근 제어를 수동으로 확인해야 합니다.
    echo 다음 쿼리를 사용하여 접근 제어를 확인할 수 있습니다: SELECT * FROM all_tab_privs WHERE table_name = 'AUDIT_TABLE';
) else if "%DB_TYPE%"=="4" (
    echo MSSQL에서 Audit Table 접근 제어를 확인 중입니다...
    sqlcmd -S your_server_name -U %DB_USER% -P %DB_PASS% -Q "SELECT permission_name, state_desc FROM sys.database_permissions WHERE major_id = OBJECT_ID('audit_table_name');"
    echo 결과를 검토하여 Audit Table에 대한 접근 제어가 적절한지 확인하세요.
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
)

:end
echo ============================================
pause
