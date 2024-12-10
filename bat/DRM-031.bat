@echo off
:: MS-SQL SA 계정 활성화 상태와 보안 설정 확인 스크립트

:: 로그 파일 생성
set LOG_FILE=sa_account_check.log
echo [MS-SQL SA 계정 점검 및 보안 설정 확인 스크립트] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ========================================= >> %LOG_FILE%

:: SQLCMD를 이용하여 MS-SQL 서버 접속 정보 설정
set DB_SERVER=localhost          :: 데이터베이스 서버 주소
set DB_USER=admin                :: 관리자 계정 (sa를 대체할 계정)
set DB_PASS=admin_password       :: 관리자 계정 비밀번호

:: SA 계정 활성화 상태 확인
echo SA 계정 활성화 상태 확인 중... >> %LOG_FILE%
sqlcmd -S %DB_SERVER% -U %DB_USER% -P %DB_PASS% -Q "SELECT name, is_disabled FROM sys.sql_logins WHERE name = 'sa';" >> %LOG_FILE%
if %errorlevel% neq 0 (
    echo [오류] MS-SQL 서버에 접속할 수 없습니다. 접속 정보를 확인하십시오. >> %LOG_FILE%
    pause
    exit /b 1
)

:: SA 계정 비밀번호 정책 확인
echo SA 계정 비밀번호 정책 확인 중... >> %LOG_FILE%
sqlcmd -S %DB_SERVER% -U %DB_USER% -P %DB_PASS% -Q "SELECT name, is_policy_checked, is_expiration_checked FROM sys.sql_logins WHERE name = 'sa';" >> %LOG_FILE%
if %errorlevel% neq 0 (
    echo [오류] 비밀번호 정책 정보를 가져올 수 없습니다. >> %LOG_FILE%
)

:: 결과 안내
echo.
echo SA 계정 점검 결과는 %LOG_FILE%에서 확인할 수 있습니다.
echo SA 계정이 활성화된 경우, 비활성화하거나 강력한 비밀번호 정책을 적용하십시오.
echo.
echo SQL 명령을 사용하여 SA 계정을 비활성화하려면 다음을 실행하십시오:
echo sqlcmd -S %DB_SERVER% -U %DB_USER% -P %DB_PASS% -Q "ALTER LOGIN sa DISABLE;"
pause
