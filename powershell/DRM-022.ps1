@echo off
setlocal

echo ============================================
echo CODE [DBM-022] 데이터베이스 설정 파일의 접근 권한 설정 확인
echo ============================================
echo [양호]: 선택한 데이터베이스 설정 파일의 접근 권한이 적절한 경우
echo [취약]: 설정 파일의 접근 권한이 미흡한 경우
echo ============================================

echo 지원하는 데이터베이스:
echo 1. MySQL
echo 2. Oracle
echo 3. PostgreSQL
echo 4. MSSQL
echo.

set /p DB_CHOICE="데이터베이스 번호를 입력하세요: "

if "%DB_CHOICE%"=="1" (
    set "FILES_TO_CHECK=C:\ProgramData\MySQL\MySQL Server X.X\my.ini"
) else if "%DB_CHOICE%"=="2" (
    set "FILES_TO_CHECK=C:\app\oracle\product\11.2.0\dbhome_1\network\admin\listener.ora"
) else if "%DB_CHOICE%"=="3" (
    set "FILES_TO_CHECK=C:\Program Files\PostgreSQL\X.X\data\postgresql.conf"
) else if "%DB_CHOICE%"=="4" (
    :: For MSSQL, specify a common configuration directory or file. Adjust as necessary for your environment.
    set "FILES_TO_CHECK=C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA"
    echo Note: Checking permissions for MSSQL data directory. Adjust path as necessary.
) else (
    echo 잘못된 선택입니다.
    goto end
)

:: 파일 권한 확인
echo.
echo Checking permissions for: %FILES_TO_CHECK%
echo.
for %%f in ("%FILES_TO_CHECK%") do (
    if exist "%%f" (
        echo Found: %%f
        echo Permissions:
        icacls "%%f"
        echo.
    ) else (
        echo WARNING: Configuration file or directory not found at "%%f"
        echo Please verify the path and ensure the database configuration file or directory is present.
        echo.
    )
)

:end
echo ============================================
pause
