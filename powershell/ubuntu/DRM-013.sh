# 도움말 함수 정의
function Write-Bar {
    Write-Host "============================================"
}

function Write-Code {
    param($code)
    Write-Host "CODE [$code] 원격 접속에 대한 접근 제어 미흡"
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
Write-Code "DBM-013"

# SQL Server 인증 또는 통합 보안 사용 설정
$SQLServer = "여러분의SqlServerInstance" # 서버/인스턴스 이름으로 업데이트하세요
$SQLDBUser = "여러분의Db사용자이름" # SQL Server 인증을 사용하는 경우 필요
$SQLDBPass = "여러분의Db비밀번호" # SQL Server 인증을 사용하는 경우 필요
$Database = "master" # 기본적으로 master 데이터베이스를 사용하거나 필요에 따라 지정

# SQL Server 인증 사용
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=$SQLServer; Database=$Database; User ID=$SQLDBUser; Password=$SQLDBPass;"

# 또는, Windows 인증 (통합 보안) 사용
# $SqlConnection.ConnectionString = "Server=$SQLServer; Database=$Database; Integrated Security=True;"

$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = "SELECT name FROM sys.server_principals WHERE type_desc = 'SQL_LOGIN' AND is_disabled = 0;"
$SqlCmd.Connection = $SqlConnection

try {
    $SqlConnection.Open()
    $reader = $SqlCmd.ExecuteReader()
    if ($reader.HasRows) {
        while ($reader.Read()) {
            $name = $reader["name"]
            # 원격 접근 제어 문제를 식별하기 위한 조건을 요구사항에 맞게 수정하세요
            Warn "활성화된 SQL Server 로그인 발견: $name"
        }
    } else {
        OK "활성화된 SQL Server 로그인이 없습니다."
    }
}
catch {
    Warn "SQL Server 접근 중 오류 발생: $_"
}
finally {
    $SqlConnection.Close()
}

Write-Bar
