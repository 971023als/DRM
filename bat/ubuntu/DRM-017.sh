@echo off
setlocal EnableDelayedExpansion

echo ============================================
echo CODE [DBM-017] 업무상 불필요한 시스템 테이블 접근 권한 존재
echo ============================================
echo [양호]: 업무상 불필요한 시스템 테이블 접근 권한이 없는 경우
echo [취약]: 업무상 불필요한 시스템 테이블 접근 권한이 존재하는 경우
echo ============================================

echo 지원하는 데이터베이스: 1. MySQL, 2. PostgreSQL, 3. MSSQL
set /p DBType="데이터베이스 유형 번호를 입력하세요 (1/2/3): "

set /p DBUser="데이터베이스 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 비밀번호를 입력하세요: "

if "!DBType!"=="1" (
    echo MySQL에서 시스템 테이블 접근 권한을 확인합니다...
    echo 다음 SQL 쿼리를 MySQL 클라이언트에서 실행하세요:
    echo SELECT GRANTEE, TABLE_SCHEMA, PRIVILEGE_TYPE FROM information_schema.SCHEMA_PRIVILEGES WHERE TABLE_SCHEMA IN ('mysql', 'information_schema', 'performance_schema');
) else if "!DBType!"=="2" (
    echo PostgreSQL에서 시스템 테이블 접근 권한을 확인합니다...
    echo 다음 SQL 쿼리를 psql 프롬프트에서 실행하세요:
    echo SELECT grantee, table_schema, privilege_type FROM information_schema.role_table_grants WHERE table_schema = 'pg_catalog';
) else if "!DBType!"=="3" (
    echo MSSQL에서 시스템 테이블 접근 권한을 확인합니다...
    echo 다음 SQL 쿼리를 sqlcmd 유틸리티에서 실행하세요:
    echo EXEC sp_helprotect NULL, 'dbo';
    echo "이 쿼리는 dbo 스키마의 모든 객체에 대한 권한을 나열합니다. 시스템 테이블에 대한 권한을 특히 주의 깊게 검토하세요."
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
    goto end
)

echo 수동으로 쿼리를 실행하고 결과를 검토하여 불필요한 시스템 테이블 접근 권한이 있는지 확인하세요.

:end
pause
