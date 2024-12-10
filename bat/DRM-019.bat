@echo off
:: 비밀번호 재사용 방지 설정 점검 스크립트
:: 결과는 password_reuse_check.log 파일에 기록됩니다.

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=password_reuse_check.log
echo [비밀번호 재사용 방지 설정 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 데이터베이스 접속 정보 설정
set DB_USER=your_username
set DB_PASS=your_password
set DB_TNS=your_database_tns

:: 비밀번호 재사용 방지 설정 점검
echo [점검 중] 비밀번호 재사용 방지 설정 확인 >> %LOG_FILE%
sqlplus -s %DB_USER%/%DB_PASS%@%DB_TNS% << EOF > temp_password_reuse.log
SET HEADING OFF
SET FEEDBACK OFF
SELECT profile, resource_name, limit 
FROM dba_profiles 
WHERE resource_name IN ('PASSWORD_REUSE_TIME', 'PASSWORD_REUSE_MAX') 
  AND limit = 'UNLIMITED';
EXIT;
EOF

:: 결과 확인 및 로그 기록
if exist temp_password_reuse.log (
    for /f "tokens=*" %%A in (temp_password_reuse.log) do (
        if "%%A" NEQ "" (
            echo [취약] 비밀번호 재사용 방지 설정이 적절하지 않음: %%A >> %LOG_FILE%
        ) else (
            echo [양호] 비밀번호 재사용 방지 설정이 적절하게 적용됨 >> %LOG_FILE%
        )
    )
) else (
    echo [오류] 비밀번호 재사용 방지 설정 정보를 가져오지 못했습니다. >> %LOG_FILE%
)

:: 점검 완료 메시지
echo 점검이 완료되었습니다. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
