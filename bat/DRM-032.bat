@echo off
:: 데이터베이스 통신 구간 및 인증 설정 점검 스크립트

:: 로그 파일 생성
set LOG_FILE=db_security_check.log
echo [데이터베이스 통신 구간 및 인증 설정 점검 스크립트] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ============================================= >> %LOG_FILE%

:: 데이터베이스 설정 파일 경로
set DB_CONFIG_PATH=C:\Database\Config
set PG_HBA_FILE=%DB_CONFIG_PATH%\pg_hba.conf
set MYSQL_CONFIG_FILE=%DB_CONFIG_PATH%\my.cnf
set MSSQL_CONFIG_FILE=%DB_CONFIG_PATH%\mssql.conf
set ORACLE_LISTENER_FILE=%DB_CONFIG_PATH%\listener.ora

:: PostgreSQL 점검
if exist "%PG_HBA_FILE%" (
    echo PostgreSQL 설정 점검 >> %LOG_FILE%
    findstr /i "hostssl" "%PG_HBA_FILE%" >nul
    if %errorlevel% neq 0 (
        echo [경고] PostgreSQL SSL 통신 암호화가 활성화되지 않았습니다. >> %LOG_FILE%
    ) else (
        echo [확인] PostgreSQL SSL 통신 암호화가 활성화되어 있습니다. >> %LOG_FILE%
    )
    findstr /i "md5" "%PG_HBA_FILE%" >nul
    if %errorlevel% neq 0 (
        echo [경고] PostgreSQL 인증 방식이 약한 방식으로 설정되어 있을 수 있습니다. >> %LOG_FILE%
    ) else (
        echo [확인] PostgreSQL 인증 방식이 강력한 방식으로 설정되어 있습니다. >> %LOG_FILE%
    )
) else (
    echo PostgreSQL 설정 파일(%PG_HBA_FILE%)이 존재하지 않습니다. >> %LOG_FILE%
)

:: MySQL 점검
if exist "%MYSQL_CONFIG_FILE%" (
    echo MySQL 설정 점검 >> %LOG_FILE%
    findstr /i "ssl" "%MYSQL_CONFIG_FILE%" >nul
    if %errorlevel% neq 0 (
        echo [경고] MySQL SSL 통신 암호화가 활성화되지 않았습니다. >> %LOG_FILE%
    ) else (
        echo [확인] MySQL SSL 통신 암호화가 활성화되어 있습니다. >> %LOG_FILE%
    )
) else (
    echo MySQL 설정 파일(%MYSQL_CONFIG_FILE%)이 존재하지 않습니다. >> %LOG_FILE%
)

:: MSSQL 점검
if exist "%MSSQL_CONFIG_FILE%" (
    echo MSSQL 설정 점검 >> %LOG_FILE%
    findstr /i "force encryption" "%MSSQL_CONFIG_FILE%" >nul
    if %errorlevel% neq 0 (
        echo [경고] MSSQL SSL 통신 암호화가 활성화되지 않았습니다. >> %LOG_FILE%
    ) else (
        echo [확인] MSSQL SSL 통신 암호화가 활성화되어 있습니다. >> %LOG_FILE%
    )
) else (
    echo MSSQL 설정 파일(%MSSQL_CONFIG_FILE%)이 존재하지 않습니다. >> %LOG_FILE%
)

:: Oracle 점검
if exist "%ORACLE_LISTENER_FILE%" (
    echo Oracle 설정 점검 >> %LOG_FILE%
    findstr /i "ssl" "%ORACLE_LISTENER_FILE%" >nul
    if %errorlevel% neq 0 (
        echo [경고] Oracle SSL 통신 암호화가 활성화되지 않았습니다. >> %LOG_FILE%
    ) else (
        echo [확인] Oracle SSL 통신 암호화가 활성화되어 있습니다. >> %LOG_FILE%
    )
) else (
    echo Oracle 설정 파일(%ORACLE_LISTENER_FILE%)이 존재하지 않습니다. >> %LOG_FILE%
)

:: 점검 완료
echo.
echo 점검 결과는 %LOG_FILE% 파일에서 확인할 수 있습니다.
pause
