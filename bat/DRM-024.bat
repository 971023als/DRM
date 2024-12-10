@echo off
:: WITH GRANT OPTION 설정 점검 스크립트
:: 점검 결과는 grant_option_check.log에 저장됩니다.

set LOG_FILE=grant_option_check.log
echo [WITH GRANT OPTION 설정 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================== >> %LOG_FILE%

:: Oracle 데이터베이스 접속 정보
set ORACLE_HOME=C:\oracle\product\19.0.0\dbhome_1
set PATH=%ORACLE_HOME%\bin;%PATH%
set USERNAME=sys
set PASSWORD=yourpassword
set TNS_ALIAS=orcl

:: SQL*Plus 실행 및 결과 기록
echo SQL*Plus 실행 중... >> %LOG_FILE%
sqlplus -s %USERNAME%/%PASSWORD%@%TNS_ALIAS% as sysdba >> %LOG_FILE% <<EOF
SET HEADING OFF;
SET FEEDBACK OFF;
SET LINESIZE 200;
SELECT grantee, privilege, admin_option
FROM dba_sys_privs
WHERE admin_option = 'YES';

SELECT grantee, privilege, grantable
FROM dba_tab_privs
WHERE grantable = 'YES';

SELECT grantee, granted_role, admin_option
FROM dba_role_privs
WHERE admin_option = 'YES';
EXIT;
EOF

echo 점검이 완료되었습니다. 결과는 %LOG_FILE% 파일에서 확인하세요.
pause
