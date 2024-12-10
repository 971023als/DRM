@echo off
:: 감사 로그 설정 및 백업 점검 스크립트
:: 결과를 db_audit_log_audit.log에 기록

setlocal enabledelayedexpansion

:: 로그 파일 설정
set LOG_FILE=db_audit_log_audit.log
echo [DB 감사 로그 설정 및 백업 점검 결과] > %LOG_FILE%
echo 점검 시간: %date% %time% >> %LOG_FILE%
echo ======================================= >> %LOG_FILE%

:: 데이터베이스 감사 로그 파일 읽기 (형식: 서버명//audit_trail//플러그인 상태//백업 경로)
for /f "tokens=1,2,3,4 delims=//" %%A in (db_audit_log.txt) do (
    set "server=%%A"
    set "audit_trail=%%B"
    set "plugin_status=%%C"
    set "backup_path=%%D"

    :: 초기값 설정
    set "policy_weak=false"

    :: 감사 로그 설정 점검
    if "!audit_trail!"=="NONE" (
        set "policy_weak=true"
        echo [취약] 서버명: !server!, audit_trail: NONE (감사 로그 수집 미설정) >> %LOG_FILE%
    )

    if "!plugin_status!"=="DISABLED" (
        set "policy_weak=true"
        echo [취약] 서버명: !server!, 플러그인 상태: DISABLED (감사 로그 플러그인 비활성화) >> %LOG_FILE%
    )

    :: 백업 경로 점검
    if not exist "!backup_path!" (
        set "policy_weak=true"
        echo [취약] 서버명: !server!, 백업 경로: !backup_path! (백업 미설정 또는 경로 없음) >> %LOG_FILE%
    )

    :: 정책이 양호한 경우 기록
    if !policy_weak!==false (
        echo [양호] 서버명: !server! >> %LOG_FILE%
    )
)

:: 완료 메시지
echo 점검 완료. 결과는 %LOG_FILE% 파일을 확인하세요.
exit /b
