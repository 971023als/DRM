@echo off
:: 사용자별 계정 분리 점검 스크립트
:: 결과는 user_account_check.log 파일에 기록됩니다.

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=user_account_check.log
echo [사용자별 계정 분리 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 데이터베이스 접속 정보 설정
set DB_USER=your_username
set DB_PASS=your_password
set DB_TNS=your_database_tns

:: 사용자 계정 점검
echo [점검 중] 데이터베이스 사용자 계정 목록 확인 >> %LOG_FILE%
sqlplus -s %DB_USER%/%DB_PASS%@%DB_TNS% << EOF > temp_user_accounts.log
SET HEADING OFF
SET FEEDBACK OFF
SELECT username, account_status, default_tablespace, temporary_tablespace
FROM dba_users;
EXIT;
EOF

:: 결과 확인 및 로그 기록
if exist temp_user_accounts.log (
    for /f "tokens=*" %%A in (temp_user_accounts.log) do (
        if "%%A" NEQ "" (
            echo %%A >> %LOG_FILE%
        )
    )
    echo [확인 필요] 공용 계정 사용 여부를 점검하세요. >> %LOG_FILE%
) else (
    echo [오류] 사용자 계정 정보를 가져오지 못했습니다. >> %LOG_FILE%
)

:: 점검 완료 메시지
echo 점검이 완료되었습니다. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
