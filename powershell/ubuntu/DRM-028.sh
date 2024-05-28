# PowerShell 스크립트로 SQL Server를 포함한 불필요한 데이터베이스 오브젝트 확인

# 사용자로부터 데이터베이스 유형 입력 받기
$DBType = Read-Host "데이터베이스 유형 번호를 입력하세요 (1. MySQL, 2. PostgreSQL, 3. Oracle, 4. SQL Server)"
$DBUser = Read-Host "데이터베이스 사용자 이름을 입력하세요"
$DBPass = Read-Host "데이터베이스 비밀번호를 입력하세요" -AsSecureString

# SQL Server용으로 비밀번호를 PSCredential로 변환
$SecurePassword = ConvertTo-SecureString $DBPass -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($DBUser, $SecurePassword)

# 불필요한 데이터베이스 오브젝트를 확인하는 함수
function Check-UnnecessaryDBObjects {
    param (
        [string]$Query,
        [string]$DBType,
        [string]$DBUser,
        [System.Management.Automation.PSCredential]$Credential
    )

    # 환경에 맞게 조정할 자리 표시자 연결 문자열
    $ConnectionString = ""

    switch ($DBType) {
        "1" { # MySQL
            # MySQL에 특화된 연결 및 쿼리 실행 로직
        }
        "2" { # PostgreSQL
            # PostgreSQL에 특화된 연결 및 쿼리 실행 로직
        }
        "3" { # Oracle
            # Oracle에 특화된 연결 및 쿼리 실행 로직
        }
        "4" { # SQL Server
            $ConnectionString = "Data Source=localhost;Initial Catalog=YourDatabaseName;User ID=$DBUser;Password=$($Credential.GetNetworkCredential().password);"
            [void][System.Reflection.Assembly]::LoadWithPartialName("System.Data")
            $Connection = New-Object System.Data.SqlClient.SqlConnection
            $Connection.ConnectionString = $ConnectionString
            $Command = New-Object System.Data.SqlClient.SqlCommand($Query, $Connection)
            try {
                $Connection.Open()
                $Reader = $Command.ExecuteReader()
                while ($Reader.Read()) {
                    $ObjectName = $Reader.GetString(0) # 오브젝트 이름이 첫 번째 열에 있다고 가정
                    Write-Host "발견된 오브젝트: $ObjectName"
                    # 여기에 오브젝트가 불필요한지 결정하는 로직을 추가하세요
                }
            }
            catch {
                Write-Host "SQL Server에 연결하는 도중 오류 발생: $_"
            }
            finally {
                $Connection.Close()
            }
        }
    }
}

# 데이터베이스 오브젝트를 나열하는 쿼리를 여기에 정의하세요. 데이터베이스 유형에 맞게 쿼리를 조정하세요.
$Query = switch ($DBType) {
    "1" { "SHOW TABLES;" } # MySQL 예제 쿼리
    "2" { "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';" } # PostgreSQL 예제 쿼리
    "3" { "SELECT table_name FROM user_tables;" } # Oracle 예제 쿼리
    "4" { "SELECT name FROM sys.objects WHERE type in ('U', 'V');" } # SQL Server의 테이블과 뷰를 나열하는 예제 쿼리
}

# 함수 호출
Check-UnnecessaryDBObjects -Query $Query -DBType $DBType -DBUser $DBUser -Credential $Credential
