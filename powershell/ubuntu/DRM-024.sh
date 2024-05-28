# SQL 쿼리 실행 및 결과 반환 함수
function Invoke-SqlQuery {
    param (
        [string]$DBType,
        [string]$DBUser,
        [string]$DBPass,
        [string]$Query
    )
    switch ($DBType) {
        "1" { # MySQL
            $ConnectionString = "server=localhost;user=$DBUser;password=$DBPass;database=mysql;"
            $Query = "SELECT GRANTEE, PRIVILEGE_TYPE FROM information_schema.user_privileges WHERE IS_GRANTABLE = 'YES';"
            $MySQLCommand = "mysql -u $DBUser -p$DBPass -Bse `"$Query`""
            return Invoke-Expression $MySQLCommand
        }
        "2" { # PostgreSQL
            $ConnectionString = "Host=localhost;Username=$DBUser;Password=$DBPass;Database=postgres;"
            $Query = "SELECT grantee, privilege_type FROM information_schema.role_usage_grants WHERE is_grantable = 'YES';"
            $PGSQLCommand = "psql -U $DBUser -c `"$Query`""
            return Invoke-Expression $PGSQLCommand
        }
        "3" { # Oracle
            Write-Host "이 스크립트에서는 Oracle 지원이 구현되지 않았습니다."
            return $null
        }
        Default {
            Write-Host "지원되지 않는 데이터베이스 유형입니다."
            return $null
        }
    }
}

# 사용자에게 데이터베이스 유형 요청
Write-Host "지원되는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle"
$DBType = Read-Host "데이터베이스 유형 번호를 입력하세요"
$DBUser = Read-Host "데이터베이스 사용자 이름을 입력하세요"
$DBPass = Read-Host -AsSecureString "데이터베이스 비밀번호를 입력하세요" # 비밀번호를 안전 문자열로 처리하는 예시입니다. 실제 사용 시 변환 필요
$DBPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DBPass))

# 플레이스홀더 쿼리, DB 유형에 따라 함수 내에서 실제 쿼리 설정
$Query = ""

# 쿼리 실행 및 권한 확인
$GrantOptionPrivileges = Invoke-SqlQuery -DBType $DBType -DBUser $DBUser -DBPass $DBPass -Query $Query

# 불필요한 권한이 부여된 경우 확인
if ($null -ne $GrantOptionPrivileges -and $GrantOptionPrivileges.Count -gt 0) {
    Write-Warning "'WITH GRANT OPTION'으로 불필요하게 부여된 다음 권한이 있습니다:"
    $GrantOptionPrivileges
} else {
    Write-Host "'WITH GRANT OPTION'으로 불필요하게 부여된 권한이 없습니다."
}
