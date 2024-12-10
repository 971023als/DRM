@echo off
setlocal EnableDelayedExpansion

echo ============================================
echo CODE [DBM-024] 불필요하게 'WITH GRANT OPTION' 옵션이 설정된 권한 확인
echo ============================================
echo [양호]: 'WITH GRANT OPTION'이 불필요하게 설정되지 않은 경우
echo [취약]: 'WITH GRANT OPTION'이 불필요하게 설정된 권한이 있는 경우
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

if "!DBType!"=="1" (
    echo MySQL에서 'WITH GRANT OPTION'으로 부여된 불필요한 권한을 확인 중...
    mysql -u !DBUser! -p!DBPass! -e "SELECT GRANTEE, PRIVILEGE_TYPE FROM information_schema.user_privileges WHERE IS_GRANTABLE = 'YES';"
) else if "!DBType!"=="2" (
    echo PostgreSQL에서 'WITH GRANT OPTION'으로 부여된 불필요한 권한을 확인 중...
    psql -U !DBUser! -w -c "SELECT grantee, privilege_type FROM information_schema.role_usage_grants WHERE is_grantable = 'YES';"
) else if "!DBType!"=="3" (
    echo Oracle에서 'WITH GRANT OPTION'으로 부여된 권한을 확인 중...
    echo SELECT grantee, privilege FROM dba_sys_privs WHERE admin_option = 'YES';
) else if "!DBType!"=="4" (
    echo MSSQL에서 'WITH GRANT OPTION'으로 부여된 불필요한 권한을 확인 중...
    echo 주의: 이 스크립트는 MSSQL의 sqlcmd 유틸리티를 사용합니다. MSSQL 서버에 연결하는 데 필요한 옵션을 적절히 조정하세요.
    sqlcmd -S 서버명 -U !DBUser! -P !DBPass! -Q "SELECT dp.name AS Grantee, perm.permission_name, perm.state_desc FROM sys.database_permissions AS perm INNER JOIN sys.database_principals AS dp ON perm.grantee_principal_id = dp.principal_id WHERE perm.state = 'W';"
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
    goto end
)

echo 설정을 검토하여 불필요하게 'WITH GRANT OPTION'이 설정된 권한이 없는지 확인하세요.

:end
echo ============================================
pause
