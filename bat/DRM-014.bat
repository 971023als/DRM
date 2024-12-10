@echo off
:: OS_ROLES 및 REMOTE_OS_ROLES 점검 스크립트
:: 결과는 os_roles_audit.log 파일에 저장

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=os_roles_audit.log
echo [운영체제 역할 인증 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 데이터베이스 접속 정보 설정
set DB_USER=your_username
set DB_PASS=your_password
set DB_TNS=your_database_tns

:: 1. OS_ROLES 파라미터 점검
echo [점검 중] OS_ROLES 파라미터 점검 >> %LOG_FILE%
sqlplus -s %DB_USER%/%DB_PASS%@%DB_TNS% << EOF > temp_os_roles.log
SET HEADING OFF
SET FEEDBACK OFF
SELECT value FROM v$parameter WHERE name='os_roles';
EXIT;
EOF

for /f "tokens=*" %%A in (temp_os_roles.log) do (
    if "%%A"=="TRUE" (
        echo [취약] OS_ROLES 값이 TRUE로 설정됨 >> %LOG_FILE%
    ) else if "%%A"=="FALSE" (
        echo [양호] OS_ROLES 값이 FALSE로 설정됨 >> %LOG_FILE%
    ) else (
        echo [점검 실패] OS_ROLES 값을 확인할 수 없음 >> %LOG_FILE%
    )
)

:: 2. REMOTE_OS_ROLES 파라미터 점검
echo [점검 중] REMOTE_OS_ROLES 파라미터 점검 >> %LOG_FILE%
sqlplus -s %DB_USER%/%DB_PASS%@%DB_TNS% << EOF > temp_remote_os_roles.log
SET HEADING OFF
SET FEEDBACK OFF
SELECT value FROM v$parameter WHERE name='remote_os_roles';
EXIT;
EOF

for /f "tokens=*" %%B in (temp_remote_os_roles.log) do (
    if "%%B"=="TRUE" (
        echo [취약] REMOTE_OS_ROLES 값이 TRUE로 설정됨 >> %LOG_FILE%
    ) else if "%%B"=="FALSE" (
        echo [양호] REMOTE_OS_ROLES 값이 FALSE로 설정됨 >> %LOG_FILE%
    ) else (
        echo [점검 실패] REMOTE_OS_ROLES 값을 확인할 수 없음 >> %LOG_FILE%
    )
)

:: 점검 완료 메시지
echo 점검이 완료되었습니다. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
