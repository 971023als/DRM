@echo off
setlocal

echo ============================================
echo CODE [DBM-020] 사용자별 계정 분리 미흡
echo ============================================
echo [양호]: 사용자별 계정 분리가 올바르게 설정된 경우
echo [취약]: 사용자별 계정 분리가 충분하지 않은 경우
echo ============================================

echo 지원하는 데이터베이스: 1. MySQL, 2. PostgreSQL, 3. MSSQL
set /p DBType="사용 중인 데이터베이스 유형을 입력하세요 (1/2/3): "

set /p DBUser="데이터베이스 관리자 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 관리자 비밀번호를 입력하세요: "

if "%DBType%"=="1" (
    echo MySQL에서 사용자별 계정 분리 설정을 확인합니다...
    mysql -u %DBUser% -p%DBPass% -e "SELECT User, Host FROM mysql.user;"
    echo 다음 쿼리 결과를 검토하여 각 사용자가 적절한 권한을 가지고 있는지 확인하세요.
) else if "%DBType%"=="2" (
    echo PostgreSQL에서 사용자별 계정 분리 설정을 확인합니다...
    psql -U %DBUser% -w -c "SELECT rolname, rolsuper, rolcreaterole, rolcreatedb, rolcanlogin FROM pg_roles;"
    echo 다음 쿼리 결과를 검토하여 각 사용자의 역할과 권한이 적절히 설정되었는지 확인하세요.
) else if "%DBType%"=="3" (
    echo MSSQL에서 사용자별 계정 분리 설정을 확인합니다...
    sqlcmd -U %DBUser% -P %DBPass% -Q "SELECT name, type_desc, is_disabled FROM sys.server_principals WHERE type IN ('U', 'S', 'G', 'R') AND name NOT IN ('sa', 'public');"
    echo 다음 쿼리 결과를 검토하여 각 사용자 및 역할이 적절한 권한을 가지고 있는지 확인하세요.
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
    goto end
)

echo 사용자별 계정 권한을 검토하여 충분한 분리가 이루어졌는지 확인하세요.

:end
pause
