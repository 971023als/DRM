# 로그 파일 설정
$logFile = "db_password_audit.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Set-Content -Path $logFile -Value "[DB 비밀번호 점검 결과]"
Add-Content -Path $logFile -Value "점검 시간: $timestamp"
Add-Content -Path $logFile -Value "======================================"

# 취약한 비밀번호 목록 정의
$weakPasswords = @(
    "scott//tiger", "system//manager", "dbsnmp//dbsnmp", "sys//changeon_install",
    "tracesvr//trace", "outln//outln", "ordplugins//ordplugins", "ordsys//ordsys",
    "ctxsys//ctxsys", "mdsys//mdsys", "adams//wood", "blake//papr",
    "clark//clth", "jones//steel", "lbacsys//lbacsys"
)

# 계정 정보 파일 읽기 (형식: 계정명//비밀번호)
$accounts = Get-Content "db_accounts.txt"

foreach ($account in $accounts) {
    # 계정 정보 분리
    $parts = $account -split "//"
    $username = $parts[0]
    $password = $parts[1]

    $weakFlag = $false
    $complexFlag = $false

    # 취약한 비밀번호 확인
    if ($weakPasswords -contains "$username//$password") {
        $weakFlag = $true
    }

    # 비밀번호 복잡도 확인
    $complexFlag = Check-Complexity -Password $password

    # 결과 기록
    if (-not $complexFlag -or $weakFlag) {
        Add-Content -Path $logFile -Value "[취약] 계정: $username, 비밀번호: $password"
    } else {
        Add-Content -Path $logFile -Value "[양호] 계정: $username"
    }
}

Write-Host "점검 완료. 결과는 $logFile 파일을 확인하세요."

# 복잡도 확인 함수
function Check-Complexity {
    param (
        [string]$Password
    )

    # 조건 초기화
    $hasLetter = $Password -match "[a-zA-Z]"
    $hasDigit = $Password -match "\d"
    $hasSpecial = $Password -match "[\W]"
    $length = $Password.Length

    # 복잡도 조건 확인
    if (($hasLetter -and $hasDigit -and $length -ge 10) -or
        ($hasLetter -and $hasDigit -and $hasSpecial -and $length -ge 8)) {
        return $true
    }
    return $false
}
