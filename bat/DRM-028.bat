@echo off
:: 데이터베이스 환경에서 불필요한 Object 점검 및 제거 스크립트

:: 로그 파일 생성
set LOG_FILE=object_check.log
echo [불필요한 데이터베이스 Object 점검 및 제거] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ========================================= >> %LOG_FILE%

:: 데이터베이스 접속 정보 설정
set DB_USER=admin          :: 데이터베이스 관리자 계정
set DB_PASS=password       :: 데이터베이스 관리자 비밀번호
set DB_NAME=my_database    :: 데이터베이스 이름
set DB_SERVER=localhost    :: 데이터베이스 서버 주소

:: 점검 명령어 실행
echo 데이터베이스 Object 목록을 점검 중... >> %LOG_FILE%
sqlcmd -S %DB_SERVER% -d %DB_NAME% -U %DB_USER% -P %DB_PASS% -Q "SELECT OBJECT_SCHEMA_NAME(object_id) AS SchemaName, name AS ObjectName, type_desc AS ObjectType FROM sys.objects WHERE type IN ('U', 'P', 'V', 'FN');" >> %LOG_FILE%
if %errorlevel% neq 0 (
    echo [오류] 데이터베이스 접속 실패! 접속 정보를 확인 후 다시 실행하세요. >> %LOG_FILE%
    pause
    exit /b 1
)

:: 불필요한 Object 제거 여부 확인
echo 불필요한 Object 점검 완료. 불필요한 Object 제거를 진행하려면 아래 내용을 확인하세요. >> %LOG_FILE%
echo [알림] 불필요한 Object 목록은 위의 로그를 통해 확인하시기 바랍니다. >> %LOG_FILE%

:: 사용자 개입을 요구하는 메시지
echo.
echo 불필요한 Object를 삭제하려면, 스크립트를 편집하여 REMOVE_OBJECT 명령어를 활성화하세요.
pause

:: (옵션) REMOVE_OBJECT 명령어 예제
:: sqlcmd -S %DB_SERVER% -d %DB_NAME% -U %DB_USER% -P %DB_PASS% -Q "DROP TABLE [불필요한테이블명]"
