@echo off
:: 데이터베이스 암호화 점검 스크립트
:: 결과를 db_encryption_audit.log에 기록

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=db_encryption_audit.log
echo [DB 중요정보 암호화 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 민감한 데이터 키워드 목록 정의
set SENSITIVE_COLUMNS=ssn password pin cardnumber

:: 데이터 파일 읽기 (형식: 테이블명//컬럼명//데이터)
for /f "tokens=1,2,3 delims=//" %%A in (db_sensitive_data.txt) do (
    set "table=%%A"
    set "column=%%B"
    set "data=%%C"

    :: 초기값 설정
    set "unencrypted=false"

    :: 평문 데이터 탐지
    for %%S in (%SENSITIVE_COLUMNS%) do (
        if "!column!"=="%%S" (
            echo !data! | findstr /r /c:"^[a-zA-Z0-9]*$" >nul
            if !errorlevel!==0 (
                set "unencrypted=true"
                echo [취약] 테이블: !table!, 컬럼: !column!, 데이터: !data! >> %LOG_FILE%
            )
        )
    )
)

:: 완료 메시지
echo 점검 완료. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
