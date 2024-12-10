@echo off
:: 사용되지 않는 세션 종료 설정 점검 스크립트
:: 결과를 db_session_timeout_audit.log에 기록

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=db_session_timeout_audit.log
echo [DB 세션 종료 설정 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 데이터베이스 계정 파일 읽기 (형식: 계정명//IDLE_TIME//wait_timeout//interactive_timeout)
for /f "tokens=1,2,3,4 delims=//" %%A in (db_session_timeout.txt) do (
    set "username=%%A"
    set "idle_time=%%B"
    set "wait_timeout=%%C"
    set "interactive_timeout=%%D"

    :: 초기값 설정
    set "policy_weak=false"

    :: IDLE_TIME 점검
    if "!idle_time!"=="UNLIMITED" (
        set "policy_weak=true"
        echo [취약] 계정명: !username!, IDLE_TIME: UNLIMITED (미설정) >> %LOG_FILE%
    ) else if !idle_time! LSS 15 (
        set "policy_weak=true"
        echo [취약] 계정명: !username!, IDLE_TIME: !idle_time! (15분 미만) >> %LOG_FILE%
    )

    :: wait_timeout 점검
    if !wait_timeout! LSS 900 (
        set "policy_weak=true"
        echo [취약] 계정명: !username!, wait_timeout: !wait_timeout! (900초 미만) >> %LOG_FILE%
    )

    :: interactive_timeout 점검
    if !interactive_timeout! LSS 900 (
        set "policy_weak=true"
        echo [취약] 계정명: !username!, interactive_timeout: !interactive_timeout! (900초 미만) >> %LOG_FILE%
    )

    :: 정책이 양호한 경우 기록
    if !policy_weak!==false (
        echo [양호] 계정명: !username! >> %LOG_FILE%
    )
)

:: 완료 메시지
echo 점검 완료. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
