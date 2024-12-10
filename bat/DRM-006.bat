@echo off
:: 데이터베이스 로그인 실패 정책 점검 스크립트
:: 결과를 db_login_policy_audit.log에 기록

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=db_login_policy_audit.log
echo [DB 로그인 실패 정책 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 데이터베이스 정책 파일 읽기 (형식: 계정명//FAILED_LOGIN_ATTEMPTS//PASSWORD_LOCK_TIME)
for /f "tokens=1,2,3 delims=//" %%A in (db_login_policy.txt) do (
    set "username=%%A"
    set "failed_attempts=%%B"
    set "lock_time=%%C"

    :: 초기값 설정
    set "policy_weak=false"

    :: FAILED_LOGIN_ATTEMPTS 점검
    if !failed_attempts! GTR 5 (
        set "policy_weak=true"
        echo [취약] 계정명: !username!, FAILED_LOGIN_ATTEMPTS: !failed_attempts! (5 초과) >> %LOG_FILE%
    )

    :: PASSWORD_LOCK_TIME 점검
    if !lock_time! LSS 15 (
        set "policy_weak=true"
        echo [취약] 계정명: !username!, PASSWORD_LOCK_TIME: !lock_time! (15분 미만) >> %LOG_FILE%
    )

    :: 정책이 양호한 경우 기록
    if !policy_weak!==false (
        echo [양호] 계정명: !username! >> %LOG_FILE%
    )
)

:: 완료 메시지
echo 점검 완료. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
