# 로그 시작
Write-Host "===================="
Write-Host "CODE [DBM-008] 주기적인 비밀번호 변경 미흡"

# 데이터베이스 유형, 사용자 이름, 비밀번호 입력 받기
$DB_TYPE = Read-Host "지원하는 데이터베이스: MySQL, PostgreSQL, MSSQL. 사용 중인 데이터베이스 유형을 입력하세요"
$DB_USER = Read-Host "$DB_TYPE 사용자 이름"
$DB_PASS = Read-Host "$DB_TYPE 비밀번호" -AsSecureString

# 주기적인 비밀번호 변경 정책 설정 확인
switch ($DB_TYPE) {
    "MySQL" {
        # MySQL에 대한 기존 로직
    }
    "PostgreSQL" {
        # PostgreSQL에 대한 기존 로직
    }
    "MSSQL" {
        # SecureString 비밀번호를 일반 텍스트로 변환
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DB_PASS)
        $PlainTextPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        # MSSQL에서 비밀번호 마지막 변경 날짜 확인을 위한 쿼리 정의
        $Query = @"
SELECT name, modify_date FROM sys.sql_logins
"@
        # 쿼리 실행 및 결과 처리
        $PASSWORD_CHANGE_POLICY = Invoke-Sqlcmd -Query $Query -Username $DB_USER -Password $PlainTextPass
    }
    default {
        Write-Host "지원되지 않는 데이터베이스 유형입니다."
        exit
    }
}

# 비밀번호 변경 정책 확인
if (-not $PASSWORD_CHANGE_POLICY) {
    Write-Host "주기적인 비밀번호 변경 정책이 설정되어 있지 않습니다."
} else {
    $MAX_DAYS = 90
    $CURRENT_DATE = Get-Date

    foreach ($row in $PASSWORD_CHANGE_POLICY) {
        $user = $row.name
        $last_changed_date = $row.modify_date

        if ($last_changed_date -lt $CURRENT_DATE.AddDays(-$MAX_DAYS)) {
            Write-Host "주기적으로 비밀번호가 변경되지 않은 계정이 있습니다: $user (마지막 변경: $last_changed_date)"
        }
    }
}

# 로그 종료
Write-Host "===================="
