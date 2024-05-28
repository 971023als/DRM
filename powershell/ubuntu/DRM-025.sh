# 데이터베이스 유형을 사용자에게 요청, SQL Server 포함
Write-Host "지원하는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle 4. SQL Server"
$DBType = Read-Host "데이터베이스 유형 번호를 입력하세요"

# 데이터베이스 자격증명 변수는 동일하게 유지
$DBUser = Read-Host "데이터베이스 사용자 이름을 입력하세요"
$DBPass = Read-Host -AsSecureString "데이터베이스 비밀번호를 입력하세요" # 비밀번호를 안전하게 처리

# 이 예제에서 SecureString 비밀번호를 일반 텍스트로 다시 변환
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DBPass)
$DBPassPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

function Check-DatabaseVersion {
    param (
        [string]$DBType,
        [string]$DBUser,
        [string]$DBPassPlainText
    )
    
    switch ($DBType) {
        # MySQL과 PostgreSQL 확인은 동일하게 유지
        
        "4" { # SQL Server
            # sqlcmd가 경로에 있는 것으로 가정
            $VersionQuery = "SELECT @@VERSION;"
            $Version = sqlcmd -S localhost -U $DBUser -P $DBPassPlainText -Q $VersionQuery |
                       Where-Object {$_ -notmatch "rows affected"} |
                       Select-Object -First 1
            # 예시 확인 (시연을 위한 단순화)
            if ($Version -like "*SQL Server 2008*") {
                Write-Warning "SQL Server 버전이 지원 종료되었습니다."
            } else {
                Write-Host "현재 SQL Server 버전은 지원됩니다."
            }
        }
        
        # Oracle과 default 케이스는 동일하게 유지
    }
}

# 버전 확인 함수 호출
Check-DatabaseVersion -DBType $DBType -DBUser $DBUser -DBPassPlainText $DBPassPlainText
