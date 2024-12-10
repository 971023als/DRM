# 로그 파일 설정
$logFile = "db_unused_accounts.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Set-Content -Path $logFile -Value "[DB 불필요 계정 점검 결과]"
Add-Content -Path $logFile -Value "점검 시간: $timestamp"
Add-Content -Path $logFile -Value "======================================"

# 현재 날짜 가져오기
$currentDate = Get-Date
$inactiveDays = 90

# 계정 파일 읽기 (형식: 계정명//최근로그인일자//계정상태)
$accounts = Get-Content "db_accounts_status.txt"

foreach ($account in $accounts) {
    # 계정 정보 분리
    $parts = $account -split "//"
    $username = $parts[0]
    $lastLogin = $parts[1]
    $accountStatus = $parts[2]

    $isInactive = $false

    # 비활성 계정 판단
    if ($accountStatus -eq "DISABLED") {
        $isInactive = $true
    } else {
        # 최근 로그인 날짜를 DateTime 형식으로 변환
        $lastLoginDate = [datetime]::ParseExact($lastLogin, "yyyyMMdd", $null)
        $daysSinceLastLogin = ($currentDate - $lastLoginDate).Days

        if ($daysSinceLastLogin -ge $inactiveDays) {
            $isInactive = $true
        }
    }

    # 결과 기록
    if ($isInactive) {
        Add-Content -Path $logFile -Value "[불필요 계정] 계정명: $username, 최근로그인: $lastLogin, 상태: $accountStatus"
    }
}

Write-Host "점검 완료. 결과는 $logFile 파일을 확인하세요."
