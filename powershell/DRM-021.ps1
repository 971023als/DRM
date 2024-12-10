@echo off
setlocal

echo ============================================
echo CODE [DBM-021] 업무상 불필요한 ODBC/OLE-DB 데이터 소스 및 드라이버 존재
echo ============================================
echo [양호]: 모든 ODBC/OLE-DB 데이터 소스 및 드라이버가 업무에 필요한 경우
echo [취약]: 업무상 필요하지 않은 ODBC/OLE-DB 데이터 소스 또는 드라이버가 존재하는 경우
echo ============================================

:: 필요한 ODBC 데이터 소스 및 드라이버 목록 정의
set necessarySources=필요한_소스_1 필요한_소스_2 필요한_소스_3

:: ODBC 데이터 소스 목록 확인 및 검사
echo ODBC 데이터 소스 목록 확인 중...
for /f "tokens=2 delims==" %%i in ('odbcconf /q ^| find "DSN="') do (
    call :checkSource %%i
)

:: OLE-DB 드라이버 목록은 배치 스크립트로 직접 나열할 수 없으므로, 이 부분은 수동 검토가 필요합니다.
echo OLE-DB 드라이버 목록은 수동으로 확인하세요. 특히 MSSQL에 대한 OLE-DB 드라이버 설정을 검토하세요.

goto :eof

:checkSource
set source=%1
:: 여기서는 %necessarySources% 변수가 정의된 파일이나 목록을 검사하는 예시입니다. 실제 환경에 맞게 수정하십시오.
if not exist "%necessarySources%" (
    echo 불필요한 ODBC 데이터 소스 발견: %source%
)
goto :eof

:end
echo ============================================
pause
