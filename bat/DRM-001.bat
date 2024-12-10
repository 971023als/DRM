@echo off
:: DB 비밀번호 점검 스크립트
:: 결과를 db_password_audit.log에 기록

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=db_password_audit.log
echo [DB 비밀번호 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 취약한 비밀번호 목록 정의
set WEAK_PASSWORDS=scott//tiger system//manager dbsnmp//dbsnmp sys//changeon_install tracesvr//trace outln//outln ordplugins//ordplugins ordsys//ordsys ctxsys//ctxsys mdsys//mdsys adams//wood blake//papr clark//clth jones//steel lbacsys//lbacsys

:: 계정 정보 파일 읽기 (형식: 계정명//비밀번호)
for /f "tokens=1,2 delims=//" %%A in (db_accounts.txt) do (
    set "username=%%A"
    set "password=%%B"

    :: 초기값 설정
    set "weak_flag=false"
    set "complex_flag=false"

    :: 취약한 비밀번호 확인
    for %%P in (%WEAK_PASSWORDS%) do (
        if "%%A//%%B"=="%%P" (
            set "weak_flag=true"
        )
    )

    :: 비밀번호 복잡도 확인
    call :CheckComplexity !password!
    if !complex_flag!==false (
        set "weak_flag=true"
    )

    :: 결과 기록
    if !weak_flag!==true (
        echo [취약] 계정: !username!, 비밀번호: !password! >> %LOG_FILE%
    ) else (
        echo [양호] 계정: !username! >> %LOG_FILE%
    )
)

:: 완료 메시지
echo 점검 완료. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b

:CheckComplexity
:: 비밀번호 복잡도 확인 함수
:: 입력: %1 (비밀번호)
set "password=%~1"
set "complex_flag=false"

:: 길이 확인
if not defined password goto :eof
set /a length=0
for /l %%I in (0,1,255) do (
    if "!password:~%%I,1!"=="" goto break
    set /a length+=1
)
:break
if %length% LSS 8 goto :eof

:: 문자 유형 확인 (영문, 숫자, 특수문자)
set "has_letter=false"
set "has_digit=false"
set "has_special=false"
for /l %%I in (0,1,%length%) do (
    set "char=!password:~%%I,1!"
    for %%C in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (
        if /i "!char!"=="%%C" set "has_letter=true"
    )
    for %%C in (0 1 2 3 4 5 6 7 8 9) do (
        if "!char!"=="%%C" set "has_digit=true"
    )
    for %%C in (!@#$%^&*()-_=+[]{}|;:'",.<>?/!) do (
        if "!char!"=="%%C" set "has_special=true"
    )
)

:: 복잡도 조건 확인
if "%has_letter%"=="true" if "%has_digit%"=="true" if "%length%" GEQ 10 set "complex_flag=true"
if "%has_letter%"=="true" if "%has_digit%"=="true" if "%has_special%"=="true" if "%length%" GEQ 8 set "complex_flag=true"

goto :eof
