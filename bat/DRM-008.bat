@echo off
:: 비밀번호 변경 주기 점검 스크립트
:: 결과를 db_password_change_audit.log에 기록

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=db_password_change_audit.log
echo [DB 비밀번호 변경 주기 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 오늘 날짜 가져오기 (YYYYMMDD)
for /f "tokens=2 delims==" %%A in ('wmic os get localdatetime /value ^| find "="') do set CURRENT_DATE=%%A
set CURRENT_DATE=%CURRENT_DATE:~0,8%

:: 데이터베이스 계정 파일 읽기 (형식: 계정명//비밀번호변경일//PASSWORD_LIFE_TIME)
for /f "tokens=1,2,3 delims=//" %%A in (db_password_change.txt) do (
    set "username=%%A"
    set "last_changed=%%B"
    set "policy_lifetime=%%C"

    :: 초기값 설정
    set "policy_weak=false"

    :: 비밀번호 변경일 점검
    call :CheckPasswordAge !last_changed!
    if !policy_weak!==true (
        echo [취약] 계정명: !username!, 최근 변경일: !last_changed! >> %LOG_FILE%
    ) else (
        echo [양호] 계정명: !username! >> %LOG_FILE%
    )
)

:: 완료 메시지
echo 점검 완료. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b

:CheckPasswordAge
:: 비밀번호 변경일 점검 함수
:: 입력: %1 (최근 비밀번호 변경일자 - YYYYMMDD)
set "last_changed=%~1"

:: 날짜 비교
set /a year=%last_changed:~0,4%
set /a month=%last_changed:~4,2%
set /a day=%last_changed:~6,2%

:: 현재 날짜 계산
set /a curr_year=%CURRENT_DATE:~0,4%
set /a curr_month=%CURRENT_DATE:~4,2%
set /a curr_day=%CURRENT_DATE:~6,2%

:: 일수 계산
set /a days_since_change=((curr_year*365 + curr_month*30 + curr_day) - (year*365 + month*30 + day))
if !days_since_change! GTR 90 (
    set "policy_weak=true"
) else (
    set "policy_weak=false"
)
goto :eof
