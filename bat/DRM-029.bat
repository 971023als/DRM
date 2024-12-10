@echo off
:: 데이터베이스 자원 사용 제한 설정(RESOURCE_LIMIT) 점검 및 활성화 스크립트

:: 로그 파일 생성
set LOG_FILE=resource_limit_check.log
echo [데이터베이스 자원 사용 제한 설정 점검 및 활성화] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ========================================= >> %LOG_FILE%

:: 데이터베이스 접속 정보 설정
set DB_USER=admin          :: 데이터베이스 관리자 계정
set DB_PASS=password       :: 데이터베이스 관리자 비밀번호
set DB_NAME=my_database    :: 데이터베이스 이름
set DB_SERVER=localhost    :: 데이터베이스 서버 주소

:: RESOURCE_LIMIT 값 확인
echo 데이터베이스 자원 사용 제한(RESOURCE_LIMIT) 상태 확인 중... >> %LOG_FILE%
sqlcmd -S %DB_SERVER% -d %DB_NAME% -U %DB_USER% -P %DB_PASS% -Q "SELECT VALUE FROM v$parameter WHERE NAME='resource_limit';" >> %LOG_FILE%
if %errorlevel% neq 0 (
    echo [오류] 데이터베이스 접속 실패! 접속 정보를 확인 후 다시 실행하세요. >> %LOG_FILE%
    pause
    exit /b 1
)

:: 현재 설정 상태 확인
findstr /i "TRUE" %LOG_FILE% >nul
if %errorlevel% neq 0 (
    echo [경고] 자원 사용 제한(RESOURCE_LIMIT)이 활성화되지 않았습니다. >> %LOG_FILE%
    echo 활성화를 위해 ALTER SYSTEM 명령을 실행해야 합니다. >> %LOG_FILE%
) else (
    echo [양호] 자원 사용 제한(RESOURCE_LIMIT)이 활성화되어 있습니다. >> %LOG_FILE%
)

:: 사용자 안내
echo.
echo 데이터베이스 자원 사용 제한(RESOURCE_LIMIT) 상태를 점검했습니다. 로그 파일을 확인하세요: %LOG_FILE%
echo.
echo RESOURCE_LIMIT 설정을 활성화하려면 다음 명령어를 실행하세요:
echo sqlcmd -S %DB_SERVER% -d %DB_NAME% -U %DB_USER% -P %DB_PASS% -Q "ALTER SYSTEM SET RESOURCE_LIMIT=TRUE SCOPE=BOTH;"
pause
