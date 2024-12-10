@echo off
:: MySQL 이중화 설정 보안 점검 스크립트
:: 평문 비밀번호 노출 여부 확인 및 보안 권고

:: 로그 파일 생성
set LOG_FILE=db_replication_security_check.log
echo [MySQL 데이터베이스 이중화 보안 점검 스크립트] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ============================================= >> %LOG_FILE%

:: MySQL 설치 경로 및 데이터 디렉토리 설정
set MYSQL_INSTALL_PATH=C:\Program Files\MySQL\MySQL Server 8.0
set MYSQL_DATA_DIR=%MYSQL_INSTALL_PATH%\data

:: MySQL 이중화 정보 파일 및 테이블 경로
set REPLICATION_INFO_TABLE=mysql.slave_master_info
set REPLICATION_INFO_FILE=%MYSQL_DATA_DIR%\mysql\slave_master_info

:: MySQL 명령어 경로
set MYSQL_CMD="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"

:: MySQL 사용자 정보 (환경 변수로 입력받도록 설정)
set MYSQL_USER=root
set MYSQL_PASSWORD=root_password

:: slave_master_info 테이블 점검
echo MySQL 데이터베이스에 연결하여 slave_master_info 정보 확인 중... >> %LOG_FILE%
%MYSQL_CMD% -u%MYSQL_USER% -p%MYSQL_PASSWORD% -e "SELECT Master_User, Master_Password FROM %REPLICATION_INFO_TABLE%;" > tmp_password_check.txt
if %errorlevel% neq 0 (
    echo [오류] MySQL 데이터베이스에 접속할 수 없습니다. >> %LOG_FILE%
    echo 접속 정보를 확인한 후 다시 실행하십시오. >> %LOG_FILE%
    pause
    exit /b 1
)

:: 평문 비밀번호 저장 여부 확인
findstr /r /c:"[a-zA-Z0-9]" tmp_password_check.txt >nul
if %errorlevel% equ 0 (
    echo [취약] slave_master_info 테이블에 평문 비밀번호가 저장되어 있습니다. >> %LOG_FILE%
    echo 보안을 위해 START SLAVE 명령 실행 시 비밀번호를 동적으로 입력하세요. >> %LOG_FILE%
) else (
    echo [양호] slave_master_info 테이블에 평문 비밀번호가 저장되지 않았습니다. >> %LOG_FILE%
)
del tmp_password_check.txt

:: slave_master_info 서버 파일 점검
echo 서버 파일 slave_master_info에서 비밀번호 평문 저장 여부 확인 중... >> %LOG_FILE%
findstr /i "password" "%REPLICATION_INFO_FILE%" >> %LOG_FILE%
if %errorlevel% equ 0 (
    echo [취약] 서버 파일 slave_master_info에 평문 비밀번호가 저장되어 있습니다. >> %LOG_FILE%
    echo 보안을 위해 START SLAVE 명령 실행 시 비밀번호를 동적으로 입력하세요. >> %LOG_FILE%
) else (
    echo [양호] 서버 파일에 평문 비밀번호가 저장되어 있지 않습니다. >> %LOG_FILE%
)

:: 점검 완료
echo.
echo MySQL 이중화 설정 보안 점검 결과는 %LOG_FILE%에서 확인할 수 있습니다.
pause
