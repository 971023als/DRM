# 함수 정의
function Write-Bar {
    Write-Host "============================================"
}

function Write-Code {
    param($code)
    Write-Host "CODE [$code]"
}

function Warn {
    param($message)
    Write-Host "WARNING: $message"
}

function OK {
    param($message)
    Write-Host "OK: $message"
}

# 스크립트 시작
Write-Bar
Write-Code "DBM-030] Audit Table에 대한 접근 제어 미흡"

# 데이터베이스 유형, 사용자 이름 및 비밀번호 입력 요청
$DB_TYPE = Read-Host "지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle 4. SQL Server. 사용 중인 데이터베이스 유형을 선택하세요 (1-4)"
$DB_USER = Read-Host "데이터베이스 사용자 이름을 입력하세요"
$DB_PASS = Read-Host "데이터베이스 비밀번호를 입력하세요" -AsSecureString

# 데이터베이스 유형에 따라 쿼리 실행
switch ($DB_TYPE) {
    "1" {
        # MySQL
        $query = "SELECT * FROM audit_table_permissions;" # 필요에 따라 쿼리 조정
        $result = mysql -u $DB_USER -p$DB_PASS -e $query
    }
    "2" {
        # PostgreSQL
        $query = "SELECT * FROM audit_table_permissions;" # 필요에 따라 쿼리 조정
        $result = psql -U $DB_USER -c $query
    }
    "3" {
        # Oracle
        $query = "SELECT * FROM audit_table_permissions;" # 필요에 따라 쿼리 조정
        $result = sqlplus -s "$DB_USER/$DB_PASS" @($query)
    }
    "4" {
        # SQL Server
        $query = "SELECT * FROM audit_table_permissions;" # 필요에 따라 쿼리 조정
        $result = Invoke-Sqlcmd -Query $query -Username $DB_USER -Password $DB_PASS
    }
    default {
        Write-Host "지원되지 않는 데이터베이스 유형입니다."
        exit
    }
}

# 접근 제어 설정 확인
if ($null -eq $result) {
    Warn "Audit Table에 대한 접근 제어가 미흡합니다."
} else {
    OK "Audit Table에 대한 접근 제어가 적절합니다: $result"
}

Write-Bar
