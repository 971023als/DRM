@echo off
:: DB 불필요 계정 점검 스크립트
:: 결과를 db_unused_accounts.log에 기록

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=db_unused_accounts.log
echo [DB 불필요 계정 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 현재 날짜 가져오기
for /f "tokens=2 delims==" %%A in ('wmic os get localdatetime /value ^| find "="') do set current_date=%%A
set current_date=%current_date:~0,8%

:: 불필요 계정 기준 (최근 로그인 일자: 90일 이상 미사용)
set INACTIVE_DAYS=90

:: 계정 파일 읽기 (형식: 계정명//최근로그인일자//계정상태)
for /f "tokens=1,2,3 delims=//" %%A in (db_accounts_status.txt) do (
    set "username=%%A"
    set "last_login=%%B"
    set "account_status=%%C"

    :: 비활성 계정 초기값
    set "inactive=false"

    :: 계정 사용 여부 판단
    if "!account_status!"=="DISABLED" (
        set "inactive=true"
    ) else (
        call :CheckInactive !last_login!
        if !inactive!==true (
            echo [불필요 계정] 계정명: !username!, 최근로그인: !last_login!, 상태: !account_status! >> %LOG_FILE%
        )
    )
)

:: 완료 메시지 출력
echo 점검 완료. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b

:CheckInactive
:: 계정 비활성화 확인 함수
:: 입력: %1 (최근 로그인 일자)
set "last_login_date=%~1"

:: 날짜 형식: YYYYMMDD로 변환
set /a last_year=!last_login_date:~0,4!
set /a last_month=!last_login_date:~4,2!
set /a last_day=!last_login_date:~6,2!

:: 현재 날짜 계산
set /a current_year=%current_date:~0,4%
set /a current_month=%current_date:~4,2%
set /a current_day=%current_date:~6,2%

:: 날짜 비교 (단순 비교)
set /a diff_days=((current_year*365 + current_month*30 + current_day) - (last_year*365 + last_month*30 + last_day))

if !diff_days! GEQ %INACTIVE_DAYS% (
    set "inactive=true"
) else (
    set "inactive=false"
)
goto :eof
