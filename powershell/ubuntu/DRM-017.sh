# MSSQL에서 불필요한 시스템 테이블 접근 권한 검사 PowerShell 스크립트

# Invoke-Sqlcmd를 사용하여 SQL 쿼리를 실행하는 함수 정의
function Invoke-SqlQuery {
    param (
        [string]$Query,
        [string]$DatabaseUser,
        [string]$DatabasePassword,
        [string]$Database,
        [string]$ServerInstance = "localhost"
    )
    
    $ConnectionString = "Server=$ServerInstance;User ID=$DatabaseUser;Password=$DatabasePassword;Database=$Database;"
    Invoke-Sqlcmd -Query $Query -ConnectionString $ConnectionString
}

# 사용자에게 데이터베이스 유형 요청
Write-Host "지원되는 데이터베이스: 1. MySQL 2. PostgreSQL 3. MSSQL"
$dbType = Read-Host "데이터베이스 유형 번호를 입력하세요"

# 사용자에게 데이터베이스 자격 증명 요청
$dbUser = Read-Host "데이터베이스 사용자 이름을 입력하세요"
$dbPass = Read-Host "데이터베이스 비밀번호를 입력하세요" -AsSecureString
$dbPassPlain = [System.Net.NetworkCredential]::new("", $dbPass).Password

# 결과 누적을 위한 자리 표시자
$results = @()

# 선택된 데이터베이스 유형에 따라 불필요한 시스템 테이블 접근 권한 검사
switch ($dbType) {
    "3" {
        # MSSQL 검사
        $Database = "master" # 필요에 따라 변경
        $ServerInstance = "localhost" # SQL 서버가 localhost에 있지 않은 경우 필요에 따라 변경
        
        $Query = @"
SELECT dp.name AS Grantee, 
       dp.type_desc AS GranteeType, 
       OBJECT_NAME(major_id) AS Object, 
       permission_name AS PermissionType
FROM sys.database_permissions AS perm
INNER JOIN sys.database_principals AS dp ON perm.grantee_principal_id = dp.principal_id
WHERE perm.class = 1 AND OBJECT_NAME(major_id) IN ('sysobjects', 'syscolumns', 'sysusers') -- 필요에 따라 객체 이름 조정
"@        
        try {
            $systemTablePrivileges = Invoke-SqlQuery -Query $Query -DatabaseUser $dbUser -DatabasePassword $dbPassPlain -Database $Database -ServerInstance $ServerInstance
            if ($systemTablePrivileges) {
                $results += "경고: 다음 사용자에게 불필요한 시스템 테이블 접근 권한이 있습니다:`n$($systemTablePrivileges | Out-String)"
            } else {
                $results += "양호: 불필요한 시스템 테이블 접근 권한이 없습니다."
            }
        } catch {
            $results += "오류: MSSQL 명령을 실행할 수 없습니다. 예외: $_"
        }
    }
    # "1" 및 "2"에 대한 케이스를 포함하여 MySQL 및 PostgreSQL을 처리합니다. 초기 스크립트 부분과 유사합니다.
    default {
        $results += "지원되지 않는 데이터베이스 유형입니다."
    }
}

# 결과 출력
$results | ForEach-Object { Write-Host $_ }
