@echo off
setlocal

echo ============================================
echo CODE [DBM-005] 데이터베이스 내 중요정보 암호화 미적용
echo ============================================
echo [양호]: 중요 데이터가 암호화되어 있는 경우
echo [취약]: 중요 데이터가 암호화되어 있지 않은 경우
echo ============================================

echo 지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle 4. MSSQL
set /p DB_TYPE="사용 중인 데이터베이스 유형을 입력하세요: "

if "%DB_TYPE%"=="1" (
    set /p MYSQL_USER="MySQL 사용자 이름을 입력하세요: "
    set /p MYSQL_PASS="MySQL 비밀번호를 입력하세요: "
    echo 중요 정보 암호화 여부 확인 중...
    mysql -u %MYSQL_USER% -p%MYSQL_PASS% -e "SELECT COUNT(*) FROM your_table WHERE your_field IS NOT NULL AND your_field != AES_DECRYPT(AES_ENCRYPT(your_field, 'your_key'), 'your_key');"
    REM 이 부분은 예시이며, 실제 쿼리는 데이터베이스 스키마에 따라 다를 수 있습니다.
) else if "%DB_TYPE%"=="2" (
    set /p PG_USER="PostgreSQL 사용자 이름을 입력하세요: "
    set /p PG_PASS="PostgreSQL 비밀번호를 입력하세요: "
    echo PostgreSQL 중요 정보 암호화 여부 확인 중...
    REM PostgreSQL 암호화 확인 로직 구현 필요
) else if "%DB_TYPE%"=="3" (
    set /p ORACLE_USER="Oracle 사용자 이름을 입력하세요: "
    set /p ORACLE_PASS="Oracle 비밀번호를 입력하세요: "
    echo Oracle 중요 정보 암호화 여부 확인 중...
    REM Oracle 암호화 확인 로직 구현 필요
) else if "%DB_TYPE%"=="4" (
    set /p MSSQL_USER="MSSQL 사용자 이름을 입력하세요: "
    set /p MSSQL_PASS="MSSQL 비밀번호를 입력하세요: "
    echo MSSQL 중요 정보 암호화 여부 확인 중...
    sqlcmd -U %MSSQL_USER% -P %MSSQL_PASS% -Q "SELECT db_name(database_id), encryption_state FROM sys.dm_database_encryption_keys;"
    REM 이 부분은 데이터베이스가 TDE(Transparent Data Encryption)를 사용하여 암호화되었는지 확인합니다.
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
    goto :end
)

:end
pause
