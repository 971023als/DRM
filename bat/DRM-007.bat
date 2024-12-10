@echo off
:: 비밀번호 복잡도 정책 점검 스크립트
:: 결과를 db_password_policy_audit.log에 기록

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=db_password_policy_audit.log
echo [DB 비밀번호 복잡도 정책 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 데이터베이스 정책 파일 읽기 (형식: 계정명//PASSWORD_VERIFY_FUNCTION//POLICY_DETAILS)
for /f "tokens=1,2,3 delims=//" %%A in (db_password_policy.txt) do (
    set "username=%%A"
    set "verify_function=%%B"
    set "policy_details=%%C"

    :: 초기값 설정
    set "policy_weak=false"

    :: 비밀번호 검증 함수 적용 여부 점검
    if "!verify_function!"=="NULL" (
        set "policy_weak=true"
        echo [취약] 계정명: !username!, PASSWORD_VERIFY_FUNCTION: 적용 안됨 >> %LOG_FILE%
    ) else (
        :: 비밀번호 검증 함수의 복잡도 정책 확인
        echo !policy_details! | findstr /r /c:"[a-zA-Z].*[0-9].*[!@#$%^&*]" >nul
        if !errorlevel!==1 (
            set "policy_weak=true"
            echo [취약] 계정명: !username!, POLICY_DETAILS: !policy_details! (복잡도 미충족) >> %LOG_FILE%
        )
    )

    :: 정책이 양호한 경우 기록
    if !policy_weak!==false (
        echo [양호] 계정명: !username! >> %LOG_FILE%
    )
)

:: 완료 메시지
echo 점검 완료. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
