@echo off
:: umask 유사 설정 점검 및 수정 스크립트
:: 데이터베이스 구동 계정의 파일 및 디렉터리 권한을 점검하고 수정합니다.

:: 로그 파일 설정
set LOG_FILE=umask_check.log
echo [파일 권한 점검 및 수정 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ========================================= >> %LOG_FILE%

:: 데이터베이스 설치 경로와 계정 설정
set DB_PATH=C:\Oracle          :: 데이터베이스 설치 경로
set DB_ACCOUNT=DBAccount       :: 데이터베이스 구동 계정

:: 파일/디렉터리 권한 점검
echo %DB_PATH% 경로의 권한 점검 중... >> %LOG_FILE%
icacls %DB_PATH% >> %LOG_FILE%
echo. >> %LOG_FILE%

:: 권한 수정 작업
echo 불필요한 권한을 제거하고, %DB_ACCOUNT% 계정에 적절한 권한을 부여합니다. >> %LOG_FILE%
icacls %DB_PATH% /remove:g "Users" /grant:r "%DB_ACCOUNT%:(F)" /T >> %LOG_FILE%

:: 결과 확인
echo 권한 수정 완료. 결과 확인: >> %LOG_FILE%
icacls %DB_PATH% >> %LOG_FILE%

:: 작업 완료 메시지
echo 작업이 완료되었습니다. 결과는 %LOG_FILE% 파일에서 확인하세요.
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
