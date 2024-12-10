@echo off
:: DB 관리자 권한 점검 스크립트
:: 결과를 db_admin_audit.log에 기록

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=db_admin_audit.log
echo [DB 관리자 권한 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 관리자 권한 목록 정의
set ADMIN_ROLES=DBA SYSDBA sysadmin serveradmin securityadmin processadmin setupadmin bulkadmin diskadmin dbcreator

:: 계정 파일 읽기 (형식: 계정명//권한목록)
for /f "tokens=1,2 delims=//" %%A in (db_admin_accounts.txt) do (
    set "username=%%A"
    set "roles=%%B"

    :: 초기값 설정
    set "unnecessary_admin=false"

    :: 관리자 권한 확인
    for %%R in (%ADMIN_ROLES%) do (
        echo !roles! | find /i "%%R" >nul
        if !errorlevel!==0 (
            set "unnecessary_admin=true"
            echo [불필요 관리자 권한] 계정명: !username!, 권한: %%R >> %LOG_FILE%
        )
    )
)

:: 완료 메시지
echo 점검 완료. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
