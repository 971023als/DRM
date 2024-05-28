# 도움말 함수 정의
function Write-Bar {
    Write-Host "============================================"
}

function Write-Code {
    param($code)
    Write-Host "CODE [$code]"
}

function Warn {
    param($message)
    Write-Host "경고: $message"
}

function OK {
    param($message)
    Write-Host "양호: $message"
}

# 스크립트 시작
Write-Bar
Write-Code "DBM-012] Listener Control Utility(lsnrctl) 보안 설정 미흡"

# 사용자로부터 Listener 설정 파일의 위치 입력 요청
$listener_ora = Read-Host "Listener 설정 파일(listener.ora)의 경로를 입력하세요"

# listener.ora 파일이 존재하는지 확인
if (Test-Path $listener_ora) {
    # ADMIN_RESTRICTIONS_LISTENER=ON 같은 보안 설정 확인
    $content = Get-Content $listener_ora
    if ($content -match "ADMIN_RESTRICTIONS_LISTENER=ON") {
        OK "Listener Control Utility 보안 설정이 적절히 적용되었습니다."
    } else {
        Warn "Listener Control Utility에 ADMIN_RESTRICTIONS_LISTENER 설정이 적용되지 않았습니다."
    }
} else {
    Warn "Listener 설정 파일이 존재하지 않습니다."
}

Write-Bar
