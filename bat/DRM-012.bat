@echo off
:: Listener 보안 설정 점검 스크립트
:: 결과를 listener_security_audit.log에 기록

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=listener_security_audit.log
echo [Oracle Listener 보안 설정 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 오라클 버전 확인
for /f "tokens=2 delims==" %%A in ('sqlplus -S / as sysdba ^< sql_script.sql') do (
    set ORACLE_VERSION=%%A
)

:: 버전 점검
if !ORACLE_VERSION! GE 11.2 (
    echo [양호] Oracle 버전 !ORACLE_VERSION!: TNS Listener 보안 설정이 기본적으로 적용됨 >> %LOG_FILE%
) else (
    echo [점검 중] Oracle 버전 !ORACLE_VERSION!: 추가 보안 설정 확인 필요 >> %LOG_FILE%
    
    :: listener.ora 파일 확인
    if exist "C:\oracle\product\11.1\db_1\network\admin\listener.ora" (
        for /f "tokens=*" %%A in ('findstr /i "ADMIN_RESTRICTIONS_LISTENER" C:\oracle\product\11.1\db_1\network\admin\listener.ora') do (
            if "%%A"=="ADMIN_RESTRICTIONS_LISTENER=OFF" (
                echo [취약] ADMIN_RESTRICTIONS_LISTENER가 OFF로 설정됨 >> %LOG_FILE%
            ) else (
                echo [양호] ADMIN_RESTRICTIONS_LISTENER가 ON으로 설정됨 >> %LOG_FILE%
            )
        )
    ) else (
        echo [취약] listener.ora 파일이 존재하지 않음 >> %LOG_FILE%
    )

    :: lsnrctl status 명령 실행
    for /f "tokens=*" %%A in ('lsnrctl status ^| findstr /i "Security"') do (
        if "%%A"=="Security: OFF" (
            echo [취약] Security 필드가 OFF로 설정됨 >> %LOG_FILE%
        ) else (
            echo [양호] Security 필드가 ON으로 설정됨 >> %LOG_FILE%
        )
    )
)

:: 완료 메시지
echo 점검 완료. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
