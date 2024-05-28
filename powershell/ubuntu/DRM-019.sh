# PowerShell 스크립트로 비밀번호 재사용 방지 설정 확인

# 변수 정의
$dbType = Read-Host "지원하는 데이터베이스: 1. MySQL, 2. PostgreSQL, 3. SQL Server. 사용 중인 데이터베이스 유형을 입력하세요"
$dbUser = Read-Host "데이터베이스 사용자 이름을 입력하세요"
$dbPass = Read-Host "데이터베이스 비밀번호를 입력하세요" -AsSecureString
$convertedPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPass))
$serverInstance = "localhost" # 필요에 따라 조정

# 데이터베이스 명령 실행 함수 정의
function Execute-DbCommand {
    param (
        [string]$dbType,
        [string]$dbUser,
        [string]$dbPass,
        [string]$query,
        [string]$serverInstance
    )
    switch ($dbType) {
        "1" {
            # MySQL 명령
            $query = "SELECT VARIABLE_VALUE FROM information_schema.global_variables WHERE VARIABLE_NAME = 'validate_password_history';"
            $command = "mysql -u $dbUser -p$dbPass -e `"$query`""
            Invoke-Expression $command
        }
        "2" {
            # PostgreSQL 명령
            $query = "SHOW password_encryption;"
            $command = "psql -U $dbUser -c `"$query`""
            Invoke-Expression $command
        }
        "3" {
            # SQL Server 명령
            # SQL Server는 구체적인 데이터베이스 설정보다 보안 정책을 사용하여 비밀번호 재사용을 관리합니다.
            # 여기서는 SQL Server 로그인에 대한 정책 존재 여부를 확인합니다.
            $query = "SELECT name, is_policy_checked FROM sys.sql_logins WHERE name = '$dbUser';"
            $command = "Invoke-Sqlcmd -Query `"$query`" -Username `"$dbUser`" -Password `"$dbPass`" -ServerInstance `"$serverInstance`""
            Invoke-Expression $command
        }
        default {
            Write-Host "지원되지 않는 데이터베이스 유형입니다."
            exit
        }
    }
}

# 데이터베이스 유형에 따라 명령 실행
$passwordReusePolicy = Execute-DbCommand -dbType $dbType -dbUser $dbUser -dbPass $convertedPass -query $query -serverInstance $serverInstance

# 정책 설정 확인 및 표시
if ([string]::IsNullOrWhiteSpace($passwordReusePolicy)) {
    Write-Host "경고: 비밀번호 재사용 방지 설정이 구성되어 있지 않습니다."
} elseif ($dbType -eq "3") {
    # SQL Server 특정 메시지
    if ($passwordReusePolicy.is_policy_checked -eq $true) {
        Write-Host "양호: SQL Server 비밀번호 정책이 $dbUser에 대해 적용됩니다."
    } else {
        Write-Host "경고: SQL Server 비밀번호 정책이 $dbUser에 대해 적용되지 않습니다."
    }
} else {
    $passwordHistory = $passwordReusePolicy -split "\r\n" | Where-Object { $_ -ne '' } | Select-Object -Last 1
    if ($dbType -eq "1" -and $passwordHistory -ge 1) {
        Write-Host "양호: MySQL 비밀번호 재사용 방지가 $passwordHistory 히스토리로 올바르게 설정되었습니다."
    } elseif ($dbType -eq "2") {
        Write-Host "양호: PostgreSQL 비밀번호 재사용 방지 정책을 확인해야 합니다."
    } else {
        Write-Host "경고: 비밀번호 재사용 방지 설정이 존재하지만 충분하지 않을 수 있습니다: $passwordHistory 히스토리."
    }
}
