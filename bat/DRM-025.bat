@echo off
:: EoS 데이터베이스 버전 점검 스크립트
:: 점검 결과는 eos_db_version_check.log에 기록됩니다.

set LOG_FILE=eos_db_version_check.log
echo [서비스 지원 종료(EoS) 데이터베이스 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ========================================= >> %LOG_FILE%

:: 데이터베이스 접속 정보 설정
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

PROMPT [데이터베이스 버전 확인];
SELECT * FROM v$version;

EXIT;
EOF

echo 점검이 완료되었습니다. 결과는 %LOG_FILE% 파일에서 확인하세요.
pause

	평가항목ID	구분	통제분야	통제구분(대)	통제구분(중)	평가항목	위험도	상세설명	"평가기반
(전자금융)"	"평가기반
(주요정보)"	"평가대상
(ORACLE)"	"평가대상
(MSSQL)"	"평가대상
(MYSQL)"	"평가대상
(MariaDB)"	"평가대상
(PostgreSQL)"	"평가대상
(Tibero)"	"판단기준
(Oracle)"	"판단방법
(Oracle)"	"판단기준
(MSSQL)"	"판단방법
(MSSQL)"	"판단기준
(MYSQL)"	"판단방법
(MYSQL)"	"판단기준
(MariaDB)"	"판단방법
(MariaDB)"	"판단기준
(PostgreSQL)"	"판단방법
(PostgreSQL)"	"판단기준
(Tibero)"	"판단방법
(Tibero)"	"주요 정보통신기반시설 취약점 분석 평가기준
(과학기술정보통신부고시 제2021-28호, 2021. 3. 29., 일부개정)"																				
