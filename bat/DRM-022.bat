@echo off
:: 주요 설정 파일 및 중요정보 파일 접근 권한 점검 스크립트
:: Windows 환경에서 사용
:: 점검 결과는 file_permission_check.log에 기록됩니다.

set LOG_FILE=file_permission_check.log
echo [주요 설정 파일 및 중요정보 파일 접근 권한 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 점검 대상 파일 목록
set FILES=C:\oracle\network\admin\listener.ora C:\oracle\network\admin\sqlnet.ora C:\oracle\dbs\spfile.ora

:: 파일 권한 점검
for %%F in (%FILES%) do (
    echo. >> %LOG_FILE%
    echo [파일: %%F] >> %LOG_FILE%
    if exist "%%F" (
        cacls "%%F" >> %LOG_FILE% 2>&1
        echo [확인 필요] %%F의 권한 설정을 점검하세요. >> %LOG_FILE%
    ) else (
        echo [오류] 파일 %%F가 존재하지 않습니다. >> %LOG_FILE%
    )
)

:: 점검 완료 메시지
echo. >> %LOG_FILE%
echo 점검이 완료되었습니다. 결과는 %LOG_FILE% 파일을 확인하세요.
echo 점검 결과가 %LOG_FILE% 파일에 저장되었습니다.
exit /b
