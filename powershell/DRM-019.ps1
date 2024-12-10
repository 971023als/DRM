@echo off
setlocal

echo ============================================
echo CODE [DBM-019] 비밀번호 재사용 방지 설정 미흡
echo ============================================
echo [양호]: 비밀번호 재사용 방지가 올바르게 설정된 경우
echo [취약]: 비밀번호 재사용 방지가 제대로 설정되지 않은 경우
echo ============================================

echo 지원하는 데이터베이스: 1. MySQL, 2. PostgreSQL, 3. MSSQL
set /p DBType="데이터베이스 유형을 입력하세요 (1/2/3): "

set /p DBUser="데이터베이스 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 비밀번호를 입력하세요: "

if "%DBType%"=="1" (
    echo MySQL에서 비밀번호 재사용 방지 설정을 확인합니다...
    mysql -u %DBUser% -p%DBPass% -e "SHOW VARIABLES LIKE 'validate_password_history';"
    echo 비밀번호 재사용 방지 설정을 검토하세요.
) else if "%DBType%"=="2" (
    echo PostgreSQL에서 비밀번호 재사용 방지 설정을 확인합니다...
    psql -U %DBUser% -c "SHOW password_encryption;"
    echo 주의: PostgreSQL에서 비밀번호 재사용 방지 정책은 다른 방식으로 설정될 수 있습니다.
) else if "%DBType%"=="3" (
    echo MSSQL에서 비밀번호 재사용 방지 설정을 확인합니다...
    sqlcmd -U %DBUser% -P %DBPass% -Q "SELECT is_policy_checked, is_expiration_checked FROM sys.sql_logins WHERE name = '%DBUser%';"
    echo MSSQL에서는 is_policy_checked 및 is_expiration_checked 컬럼을 통해 비밀번호 정책 및 만료 정책을 확인할 수 있습니다.
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
    goto end
)

echo 설정 확인 후, 비밀번호 재사용 방지가 적절히 구성되었는지 확인하세요.

:end
pause
