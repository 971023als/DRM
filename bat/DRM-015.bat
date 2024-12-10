@echo off
:: PUBLIC Role 권한 점검 스크립트
:: 결과는 public_role_audit.log 파일에 저장

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=public_role_audit.log
echo [PUBLIC Role 권한 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 데이터베이스 접속 정보 설정
set DB_USER=your_username
set DB_PASS=your_password
set DB_TNS=your_database_tns

:: 1. PUBLIC Role에 부여된 시스템 권한 점검
echo [점검 중] PUBLIC Role에 부여된 시스템 권한 점검 >> %LOG_FILE%
sqlplus -s %DB_USER%/%DB_PASS%@%DB_TNS% << EOF > temp_system_privileges.log
SET HEADING OFF
SET FEEDBACK OFF
SELECT privilege FROM dba_sys_privs WHERE grantee='PUBLIC';
EXIT;
EOF

for /f "tokens=*" %%A in (temp_system_privileges.log) do (
    if "%%A" NEQ "" (
        echo [취약] PUBLIC Role에 불필요한 시스템 권한 %%A 존재 >> %LOG_FILE%
    ) else (
        echo [양호] PUBLIC Role에 불필요한 시스템 권한이 없습니다 >> %LOG_FILE%
    )
)

:: 2. PUBLIC Role에 부여된 Role 점검
echo [점검 중] PUBLIC Role에 부여된 역할(Role) 점검 >> %LOG_FILE%
sqlplus -s %DB_USER%/%DB_PASS%@%DB_TNS% << EOF > temp_roles.log
SET HEADING OFF
SET FEEDBACK OFF
SELECT granted_role FROM dba_role_privs WHERE grantee='PUBLIC';
EXIT;
EOF

for /f "tokens=*" %%B in (temp_roles.log) do (
    if "%%B" NEQ "" (
        echo [취약] PUBLIC Role에 불필요한 Role %%B 존재 >> %LOG_FILE%
    ) else (
        echo [양호] PUBLIC Role에 불필요한 Role이 없습니다 >> %LOG_FILE%
    )
)

:: 3. PUBLIC Role에 부여된 Object 권한 점검
echo [점검 중] PUBLIC Role에 부여된 Object 권한 점검 >> %LOG_FILE%
sqlplus -s %DB_USER%/%DB_PASS%@%DB_TNS% << EOF > temp_object_privileges.log
SET HEADING OFF
SET FEEDBACK OFF
SELECT table_name, privilege FROM dba_tab_privs WHERE grantee='PUBLIC';
EXIT;
EOF

for /f "tokens=*" %%C in (temp_object_privileges.log) do (
    if "%%C" NEQ "" (
        echo [취약] PUBLIC Role에 불필요한 Object 권한 %%C 존재 >> %LOG_FILE%
    ) else (
        echo [양호] PUBLIC Role에 불필요한 Object 권한이 없습니다 >> %LOG_FILE%
    )
)

:: 점검 완료 메시지
echo 점검이 완료되었습니다. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
