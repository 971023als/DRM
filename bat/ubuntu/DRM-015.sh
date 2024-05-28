@echo off
setlocal

echo =============================================
echo CODE [DBM-015] Public Role에 불필요한 권한 존재
echo =============================================
echo [양호]: Public Role에 불필요한 권한이 부여되지 않은 경우
echo [취약]: Public Role에 불필요한 권한이 부여된 경우
echo =============================================

echo 지원하는 데이터베이스: MySQL, Oracle, MSSQL
set /p DB_TYPE="사용 중인 데이터베이스 유형을 입력하세요: "

set /p DB_USER="데이터베이스 사용자 이름을 입력하세요: "
set /p DB_PASS="데이터베이스 비밀번호를 입력하세요: "

if "%DB_TYPE%"=="MySQL" (
    echo MySQL에 대한 PUBLIC 역할 개념은 다르게 적용됩니다. 아래 쿼리는 모든 사용자 권한을 나열합니다:
    echo SHOW GRANTS FOR '%DB_USER%';
) else if "%DB_TYPE%"=="Oracle" (
    echo Oracle에서 PUBLIC 역할에 부여된 권한 확인:
    echo 이 쿼리를 SQL*Plus 또는 다른 Oracle SQL 클라이언트에서 실행하세요:
    echo CONNECT %DB_USER%/%DB_PASS%
    echo "SELECT PRIVILEGE FROM dba_sys_privs WHERE GRANTEE = 'PUBLIC';"
) else if "%DB_TYPE%"=="MSSQL" (
    echo MSSQL에서 PUBLIC 역할에 부여된 권한 확인:
    echo SQL Server Management Studio(SSMS)를 사용하여 다음 쿼리를 실행하세요:
    echo "USE [YourDatabaseName];"
    echo "SELECT dp.permission_name, dp.state_desc, o.name, o.type_desc"
    echo "FROM sys.database_permissions AS dp"
    echo "JOIN sys.objects AS o ON dp.major_id=o.object_id"
    echo "WHERE dp.grantee_principal_id = DATABASE_PRINCIPAL_ID('public');"
    echo "데이터베이스 이름을 [YourDatabaseName]에 적절히 교체하세요."
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
    goto end
)

echo "PUBLIC 역할에 부여된 불필요한 권한을 확인해 주세요."
echo "불필요한 권한이 있다면, 보안을 강화하기 위해 적절한 조치를 취하세요."

:end
echo =============================================
pause
