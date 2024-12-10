@echo off
setlocal

echo ============================================
echo CODE [DBM-029] 데이터베이스의 자원 사용 제한 설정 미흡
echo ============================================
echo [양호]: 데이터베이스의 자원 사용 제한이 적절하게 설정된 경우
echo [취약]: 데이터베이스의 자원 사용 제한이 미흡한 경우
echo ============================================

echo 지원하는 데이터베이스:
echo 1. MySQL
echo 2. PostgreSQL
set /p DBType="데이터베이스 유형 번호를 입력하세요: "

set /p DBUser="데이터베이스 사용자 이름을 입력하세요: "
set /p DBPass="데이터베이스 비밀번호를 입력하세요: "
set DBHost=localhost

if "%DBType%"=="1" (
    echo MySQL 자원 사용 제한을 확인 중...
    mysql -u %DBUser% -p%DBPass% -h %DBHost% -e "SHOW VARIABLES LIKE 'max_connections';"
    if errorlevel 1 (
        echo 경고: MySQL 자원 사용 제한을 검색하지 못했습니다.
    ) else (
        echo 양호: MySQL 자원 사용 제한 설정이 확인되었습니다.
    )
) else if "%DBType%"=="2" (
    echo PostgreSQL 자원 사용 제한을 확인 중...
    psql -U %DBUser% -h %DBHost% -W %DBPass% -c "SHOW max_connections;"
    if errorlevel 1 (
        echo 경고: PostgreSQL 자원 사용 제한을 검색하지 못했습니다.
    ) else (
        echo 양호: PostgreSQL 자원 사용 제한 설정이 확인되었습니다.
    )
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
    goto end
)

:end
echo ============================================
pause
