@echo off
setlocal

echo ============================================
echo CODE [DBM-012] 데이터베이스 네트워크 리스너 보안 설정
echo ============================================
echo 1. Oracle Listener Control Utility (lsnrctl) 보안 설정
echo 2. MSSQL 서버 네트워크 설정 및 방화벽 규칙
set /p DB_TYPE="데이터베이스 유형을 선택하세요 (1-2): "

if "%DB_TYPE%"=="1" (
    :: Oracle checks
    set /p listener_ora="Listener 설정 파일(listener.ora)의 경로를 입력하세요: "
    if not exist "%listener_ora%" (
        echo 경고: Listener 설정 파일이 존재하지 않습니다.
    ) else (
        findstr /C:"ADMIN_RESTRICTIONS_LISTENER=ON" "%listener_ora%" > nul
        if errorlevel 1 (
            echo 경고: Listener Control Utility에 ADMIN_RESTRICTIONS_LISTENER 설정이 적용되지 않았습니다.
        ) else (
            echo 양호: Listener Control Utility 보안 설정이 적절히 적용되었습니다.
        )
    )
) else if "%DB_TYPE%"=="2" (
    :: MSSQL checks
    echo MSSQL 서버 네트워크 설정:
    echo - SQL Server Configuration Manager를 사용하여 TCP/IP 프로토콜이 활성화되어 있는지 확인하세요.
    echo - SQL Server 인스턴스에 대한 적절한 Windows 방화벽 규칙이 구성되어 있는지 확인하세요.
    echo 수동 확인 필요: 이 작업은 SQL Server Configuration Manager 및 Windows 방화벽 설정을 통해 수행해야 합니다.
) else (
    echo 지원되지 않는 데이터베이스 유형입니다.
)

:end
echo ============================================
pause
