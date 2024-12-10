@echo off
:: 시스템 테이블 접근 권한 점검 스크립트
:: 결과는 system_table_access.log 파일에 저장

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=system_table_access.log
echo [시스템 테이블 접근 권한 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 데이터베이스 접속 정보 설정
set DB_USER=your_username
set DB_PASS=your_password
set DB_TNS=your_database_tns

:: 시스템 테이블 접근 권한 목록 점검
echo [점검 중] 시스템 테이블 접근 권한 점검 >> %LOG_FILE%
sqlplus -s %DB_USER%/%DB_PASS%@%DB_TNS% << EOF > temp_sys_table_access.log
SET HEADING OFF
SET FEEDBACK OFF
SELECT grantee, table_name, privilege 
FROM all_tab_privs 
WHERE owner IN ('SYS', 'INFORMATION_SCHEMA', 'PG_CATALOG')
  AND grantee NOT IN ('DBA', 'SYSTEM', 'ADMIN');
EXIT;
EOF

:: 결과 확인 및 로그 기록
if exist temp_sys_table_access.log (
    for /f "tokens=*" %%A in (temp_sys_table_access.log) do (
        if "%%A" NEQ "" (
            echo [주의] 불필요한 권한 발견: %%A >> %LOG_FILE%
        ) else (
            echo [안전] 불필요한 시스템 테이블 접근 권한 없음 >> %LOG_FILE%
        )
    )
) else (
    echo [오류] 시스템 테이블 접근 권한을 가져오지 못했습니다. >> %LOG_FILE%
)

:: 점검 완료 메시지
echo 점검이 완료되었습니다. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
