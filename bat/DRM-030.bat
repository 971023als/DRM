@echo off
:: 감사 로그 테이블(AUD$) 접근 권한 점검 및 수정 스크립트

:: 로그 파일 생성
set LOG_FILE=audit_table_check.log
echo [Audit Table 접근 권한 점검 및 수정 스크립트] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ========================================= >> %LOG_FILE%

:: 데이터베이스 접속 정보 설정
set DB_USER=admin          :: 데이터베이스 관리자 계정
set DB_PASS=password       :: 데이터베이스 관리자 비밀번호
set DB_NAME=my_database    :: 데이터베이스 이름
set DB_SERVER=localhost    :: 데이터베이스 서버 주소

:: AUD$ 테이블 접근 권한 점검
echo AUD$ 테이블 접근 권한 점검 중... >> %LOG_FILE%
sqlcmd -S %DB_SERVER% -d %DB_NAME% -U %DB_USER% -P %DB_PASS% -Q "SELECT GRANTEE, PRIVILEGE FROM sys.database_permissions WHERE major_id = OBJECT_ID('sys.aud$');" >> %LOG_FILE%
if %errorlevel% neq 0 (
    echo [오류] MS-SQL 서버에 연결하지 못했습니다. 접속 정보를 확인하세요. >> %LOG_FILE%
    pause
    exit /b 1
)

:: 결과 안내
echo.
echo AUD$ 테이블 접근 권한 점검 결과를 로그 파일에서 확인하세요: %LOG_FILE%
echo.
echo 일반 사용자 계정의 수정/삭제 권한을 제거하려면 다음 명령어를 실행하세요:
echo sqlcmd -S %DB_SERVER% -d %DB_NAME% -U %DB_USER% -P %DB_PASS% -Q "REVOKE DELETE, UPDATE, INSERT ON SYS.AUD$ FROM [일반 사용자 계정];"
pause
