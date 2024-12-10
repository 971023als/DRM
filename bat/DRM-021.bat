@echo off
:: ODBC/OLE-DB 데이터 소스 및 드라이버 점검 스크립트
:: 결과는 odbc_driver_check.log 파일에 기록됩니다.

set LOG_FILE=odbc_driver_check.log
echo [ODBC/OLE-DB 데이터 소스 및 드라이버 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 사용자 DSN 확인
echo [사용자 DSN(User DSN) 점검] >> %LOG_FILE%
odbcconf /L > temp_user_dsn.log
if exist temp_user_dsn.log (
    type temp_user_dsn.log >> %LOG_FILE%
    del temp_user_dsn.log
) else (
    echo [오류] 사용자 DSN 정보를 가져오지 못했습니다. >> %LOG_FILE%
)

:: 시스템 DSN 확인
echo. >> %LOG_FILE%
echo [시스템 DSN(System DSN) 점검] >> %LOG_FILE%
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" >> %LOG_FILE% 2>&1
if errorlevel 1 (
    echo [오류] 시스템 DSN 정보를 가져오지 못했습니다. >> %LOG_FILE%
)

:: ODBC 드라이버 확인
echo. >> %LOG_FILE%
echo [ODBC 드라이버 점검] >> %LOG_FILE%
reg query "HKLM\SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers" >> %LOG_FILE% 2>&1
if errorlevel 1 (
    echo [오류] ODBC 드라이버 정보를 가져오지 못했습니다. >> %LOG_FILE%
)

:: 점검 완료 메시지
echo. >> %LOG_FILE%
echo 점검이 완료되었습니다. 결과는 %LOG_FILE% 파일을 확인하세요.
echo 점검 결과가 %LOG_FILE% 파일에 저장되었습니다.
exit /b
