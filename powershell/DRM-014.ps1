@echo off
echo ============================================
echo CODE [DBM-014] 취약한 운영체제 역할 인증 기능 사용
echo ============================================

echo 지원하는 데이터베이스:
echo 1. Oracle
echo 2. MSSQL
set /p DB_TYPE="데이터베이스 유형을 선택하세요 (1-2): "

if "%DB_TYPE%"=="1" (
    echo Oracle 데이터베이스에서 OS_ROLES 및 REMOTE_OS_ROLES 확인 방법:
    echo 1. SQL*Plus를 엽니다.
    echo 2. Oracle DB 사용자 이름과 비밀번호를 사용하여 데이터베이스에 연결합니다.
    echo    예시: CONNECT 사용자이름/비밀번호@데이터베이스
    echo 3. OS_ROLES 및 REMOTE_OS_ROLES의 상태를 확인하기 위해 다음 쿼리를 실행합니다:
    echo    SELECT value FROM v$parameter WHERE name = 'os_roles';
    echo    SELECT value FROM v$parameter WHERE name = 'remote_os_roles';
    echo 4. 안전한 구성을 위해 두 설정 모두 FALSE로 설정되어 있는지 확인합니다.
    echo.
    echo 수동 조치 필요: Oracle 데이터베이스 역할을 확인하기 위해 위의 지시사항을 따르십시오.
) else if "%DB_TYPE%"=="2" (
    echo MSSQL 데이터베이스에서 운영 체제 역할 인증 기능 사용 확인 방법:
    echo 1. SQL Server Management Studio(SSMS)를 엽니다.
    echo 2. 대상 SQL Server 인스턴스에 연결합니다.
    echo 3. 서버 인스턴스를 마우스 오른쪽 버튼으로 클릭하고 '속성'을 선택합니다.
    echo 4. '보안' 페이지에서 '서버 인증' 섹션을 검토합니다.
    echo 5. 'SQL Server 및 Windows 인증 모드'가 선택되어 있는지 확인합니다.
    echo    이는 Windows 인증만 사용하는 것보다 유연하지만, 보안 정책에 따라 적절히 관리되어야 합니다.
    echo.
    echo 수동 조치 필요: MSSQL 데이터베이스의 인증 모드를 검토하고, 필요에 따라 보안 정책을 강화하세요.
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
)

echo ============================================
pause
