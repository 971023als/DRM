@echo off
setlocal

echo ============================================
echo CODE [DBM-006] 로그인 실패 횟수에 따른 접속 제한 설정 미흡
echo ============================================
echo [양호]: 로그인 실패 횟수에 따른 접속 제한이 설정되어 있는 경우
echo [취약]: 로그인 실패 횟수에 따른 접속 제한이 설정되어 있지 않은 경우
echo ============================================

echo 지원하는 데이터베이스: 1. MySQL 2. MSSQL
set /p DB_TYPE="사용 중인 데이터베이스 유형을 입력하세요: "

if "%DB_TYPE%"=="1" (
    set /p MYSQL_USER="MySQL 사용자 이름을 입력하세요: "
    set /p MYSQL_PASS="MySQL 비밀번호를 입력하세요: "
    echo 로그인 실패 횟수에 따른 접속 제한 설정을 확인 중...
    mysql -u %MYSQL_USER% -p%MYSQL_PASS% -e "SHOW VARIABLES LIKE 'login_failure_limit';" > tmp_result.txt

    findstr "login_failure_limit" tmp_result.txt > nul
    if errorlevel 1 (
        echo [취약]: 로그인 실패 횟수에 따른 접속 제한이 설정되어 있지 않습니다.
    ) else (
        echo [양호]: 로그인 실패 횟수에 따른 접속 제한이 설정되어 있습니다.
    )

    del tmp_result.txt
) else if "%DB_TYPE%"=="2" (
    echo MSSQL의 로그인 실패 횟수에 따른 접속 제한 설정은 SQL Server Management Studio(SSMS)나 Windows 정책을 통해 관리됩니다.
    echo 해당 설정을 검토해 주세요.
) else (
    echo 지원하지 않는 데이터베이스 유형입니다.
)

:end
pause
