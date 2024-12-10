@echo off
:: 데이터베이스 패치 상태 점검 스크립트
:: 결과는 patch_status_audit.log 파일에 저장

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=patch_status_audit.log
echo [데이터베이스 패치 상태 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 데이터베이스 접속 정보 설정
set DB_USER=your_username
set DB_PASS=your_password
set DB_TNS=your_database_tns

:: 현재 패치 상태 확인
echo [점검 중] 데이터베이스 패치 상태 확인 >> %LOG_FILE%
sqlplus -s %DB_USER%/%DB_PASS%@%DB_TNS% << EOF > temp_patch_status.log
SET HEADING OFF
SET FEEDBACK OFF
SELECT * FROM dba_registry_sqlpatch ORDER BY action_time DESC;
EXIT;
EOF

:: 결과 확인 및 로그 기록
if exist temp_patch_status.log (
    for /f "tokens=*" %%A in (temp_patch_status.log) do (
        if "%%A" NEQ "" (
            echo [정보] 현재 패치 내역: %%A >> %LOG_FILE%
        ) else (
            echo [취약] 최신 보안 패치가 적용되지 않았을 가능성 있음 >> %LOG_FILE%
        )
    )
) else (
    echo [오류] 패치 내역을 가져오지 못했습니다. >> %LOG_FILE%
)

:: 점검 완료 메시지
echo 점검이 완료되었습니다. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
