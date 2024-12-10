@echo off
:: 원격 접속 접근 제어 점검 스크립트
:: 결과는 remote_access_audit.log 파일에 저장

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=remote_access_audit.log
echo [데이터베이스 원격 접속 접근 제어 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 1. sqlnet.ora 파일 점검
set SQLNET_ORA=C:\oracle\product\11.1\db_1\network\admin\sqlnet.ora
if exist "%SQLNET_ORA%" (
    echo [점검 중] sqlnet.ora 파일 점검 >> %LOG_FILE%
    for /f "tokens=*" %%A in ('findstr /i "TCP.VALIDNODE_CHECKING" "%SQLNET_ORA%"') do (
        if "%%A"=="TCP.VALIDNODE_CHECKING=NO" (
            echo [취약] TCP.VALIDNODE_CHECKING 값이 NO로 설정됨 >> %LOG_FILE%
        ) else (
            echo [양호] TCP.VALIDNODE_CHECKING 값이 YES로 설정됨 >> %LOG_FILE%
        )
    )
) else (
    echo [취약] sqlnet.ora 파일이 존재하지 않음 >> %LOG_FILE%
)

:: 2. 데이터베이스 계정 호스트 제한 점검 (MySQL)
echo [점검 중] 데이터베이스 계정의 호스트 제한 점검 >> %LOG_FILE%
mysql -u root -e "SELECT User, Host FROM mysql.user;" > temp_user_host.log
for /f "tokens=1,2 delims= " %%U %%H in (temp_user_host.log) do (
    if "%%H"=="%" (
        echo [취약] 계정 %%U 의 Host 설정이 %%H (모든 원격 호스트 허용) >> %LOG_FILE%
    ) else (
        echo [양호] 계정 %%U 의 Host 설정이 %%H >> %LOG_FILE%
    )
)
del temp_user_host.log

:: 3. pg_hba.conf 파일 점검 (PostgreSQL)
set PG_HBA_CONF=C:\Program Files\PostgreSQL\13\data\pg_hba.conf
if exist "%PG_HBA_CONF%" (
    echo [점검 중] pg_hba.conf 파일 점검 >> %LOG_FILE%
    for /f "tokens=*" %%A in ('findstr /i "0.0.0.0/0" "%PG_HBA_CONF%"') do (
        echo [취약] 0.0.0.0/0 로 모든 IP 접근 허용 설정이 존재 >> %LOG_FILE%
    )
) else (
    echo [취약] pg_hba.conf 파일이 존재하지 않음 >> %LOG_FILE%
)

:: 점검 완료 메시지
echo 점검이 완료되었습니다. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
