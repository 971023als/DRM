# 헤더를 표시하는 함수 정의
function Write-Bar {
    Write-Host "=================================================="
}

# 코드를 표시하는 함수 정의
function Write-Code {
    param($code)
    Write-Host "CODE [$code]"
}

# 설정에 대해 경고하는 함수 정의
function Warn {
    param($message)
    Write-Host "경고: $message"
}

# 설정이 확인된 것을 알리는 함수 정의
function OK {
    param($message)
    Write-Host "양호: $message"
}

Write-Bar
Write-Code "DBM-009] 사용되지 않는 세션 종료 미흡"

# 데이터베이스 유형 입력 받기
$DB_TYPE = Read-Host "지원하는 데이터베이스: MySQL, PostgreSQL, MSSQL. 사용 중인 데이터베이스 유형을 입력하세요"

# 데이터베이스 유형에 따라 실행
switch ($DB_TYPE) {
    "MySQL" {
        # MySQL 로직...
    }
    "PostgreSQL" {
        # PostgreSQL 로직...
    }
    "MSSQL" {
        $MSSQL_USER = Read-Host "MSSQL 사용자 이름을 입력하세요"
        $MSSQL_PASS = Read-Host "MSSQL 비밀번호를 입력하세요" -AsSecureString
        $ConnectionString = "Server=localhost; User ID=$MSSQL_USER; Password=$([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($MSSQL_PASS)));"
        $QUERY = "SELECT name, value_in_use FROM sys.configurations WHERE name = 'remote query timeout';"
        $SESSION_TIMEOUT = Invoke-Sqlcmd -Query $QUERY -ConnectionString $ConnectionString
    }
    default {
        Write-Host "지원되지 않는 데이터베이스 유형입니다."
        exit
    }
}

# MSSQL에 대한 세션 종료 시간 설정 확인 및 표시
if ($DB_TYPE -eq "MSSQL") {
    if ($SESSION_TIMEOUT.value_in_use -eq 0) {
        Warn "MSSQL 세션 종료 시간이 무제한으로 설정되어 있습니다."
    } else {
        OK "MSSQL 세션 종료 시간이 설정되어 있습니다: $($SESSION_TIMEOUT.value_in_use)초."
    }
} elseif (-not [string]::IsNullOrWhiteSpace($SESSION_TIMEOUT)) {
    # MySQL 및 PostgreSQL 로직...
}

Write-Bar
