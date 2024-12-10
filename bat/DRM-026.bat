@echo off
:: umask 유사 설정 점검 및 수정 스크립트
:: 데이터베이스 구동 계정의 파일 및 디렉터리 권한을 점검하고 수정합니다.

:: 로그 파일 설정
set LOG_FILE=umask_check.log
echo [파일 권한 점검 및 수정 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ========================================= >> %LOG_FILE%

:: 데이터베이스 설치 경로와 계정 설정
set DB_PATH=C:\Oracle          :: 데이터베이스 설치 경로
set DB_ACCOUNT=DBAccount       :: 데이터베이스 구동 계정

:: 파일/디렉터리 권한 점검
echo %DB_PATH% 경로의 권한 점검 중... >> %LOG_FILE%
icacls %DB_PATH% >> %LOG_FILE%
if %errorlevel% neq 0 (
    echo [오류] 권한 점검 중 문제가 발생했습니다. 경로를 확인하세요. >> %LOG_FILE%
    pause
    exit /b 1
)

:: 권한 수정 작업
echo 불필요한 권한을 제거하고, %DB_ACCOUNT% 계정에 적절한 권한을 부여합니다. >> %LOG_FILE%
icacls %DB_PATH% /remove:g "Users" /grant:r "%DB_ACCOUNT%:(F)" /T >> %LOG_FILE%
if %errorlevel% neq 0 (
    echo [오류] 권한 수정 작업 중 문제가 발생했습니다. >> %LOG_FILE%
    pause
    exit /b 1
)

:: 결과 확인
echo 권한 수정 완료. 결과 확인: >> %LOG_FILE%
icacls %DB_PATH% >> %LOG_FILE%

:: 작업 완료 메시지
echo 작업이 완료되었습니다. 결과는 %LOG_FILE% 파일에서 확인하세요.
pause
