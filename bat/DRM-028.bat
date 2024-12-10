@echo off
:: 데이터베이스 환경에서 불필요한 Object 점검 및 제거 스크립트
:: 로그 파일 생성
set LOG_FILE=object_check.log
echo [불필요한 데이터베이스 Object 점검 및 제거] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ========================================= >> %LOG_FILE%

:: 데이터베이스 접속 정보 설정
set DB_USER=admin          :: 데이터베이스 관리자 계정
set DB_PASS=password       :: 데이터베이스 관리자 비밀번호
set DB_NAME=my_database    :: 데이터베이스 이름
set DB_SERVER=localhost    :: 데이터베이스 서버 주소

:: 점검 명령어 실행
echo 데이터베이스 Object 목록을 점검 중... >> %LOG_FILE%
sqlcmd -S %DB_SERVER% -d %DB_NAME% -U %DB_USER% -P %DB_PASS% -Q "SELECT OBJECT_SCHEMA_NAME(object_id) AS SchemaName, name AS ObjectName, type_desc AS ObjectType FROM sys.objects WHERE type IN ('U', 'P', 'V', 'FN')" >> %LOG_FILE%

:: 불필요한 Object 제거 여부 확인
echo 불필요한 Object 점검 완료. 불필요한 Object 제거를 진행하려면 아래 내용을 확인하세요. >> %LOG_FILE%

:: 사용자 개입을 요구하는 메시지
echo.
echo 불필요한 Object를 삭제하려면, 스크립트를 편집하여 REMOVE_OBJECT 명령어를 활성화하세요.
pause

:: (옵션) REMOVE_OBJECT 명령어 예제
:: sqlcmd -S %DB_SERVER% -d %DB_NAME% -U %DB_USER% -P %DB_PASS% -Q "DROP TABLE [불필요한테이블명]"


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
