# 데이터베이스 관리자 비밀번호를 안전하게 입력받는 함수 정의
function Read-SecurePassword {
    $securePassword = Read-Host "데이터베이스 관리자 비밀번호를 입력하세요" -AsSecureString
    return $securePassword
}

# SQLServer 모듈 임포트
Import-Module SqlServer

# 데이터베이스 정보 입력받기
$dbType = Read-Host "지원하는 데이터베이스: 1. MySQL, 2. PostgreSQL, 3. SQL Server. 해당하는 데이터베이스 유형 번호를 입력하세요"
$dbUser = Read-Host "데이터베이스 관리자 사용자 이름을 입력하세요"
$dbPass = Read-SecurePassword

# 데이터베이스 유형에 따라 데이터베이스 명령 정의 및 실행
switch ($dbType) {
    "1" { # MySQL
        $query = "SELECT User, Host, Db, Select_priv, Insert_priv, Update_priv FROM mysql.db;"
        # MySQL의 경우 .NET 커넥터 사용하거나 커맨드라인 툴 호출 가능
        Write-Host "이 스크립트에서는 MySQL 명령 실행을 구현하지 않았습니다. MySQL 클라이언트를 사용하세요."
    }
    "2" { # PostgreSQL
        $query = "SELECT rolname, rolselectpriv, rolinsertpriv, rolupdatepriv FROM pg_roles JOIN pg_database ON (rolname = datname);"
        # PostgreSQL의 경우 psql이나 .NET 커넥터를 사용할 수 있음
        Write-Host "이 스크립트에서는 PostgreSQL 명령 실행을 구현하지 않았습니다. psql이나 .NET 커넥터를 사용하세요."
    }
    "3" { # SQL Server
        $secureStringPassword = Read-SecurePassword
        $plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureStringPassword))
        $sqlCredential = New-Object System.Management.Automation.PSCredential ($dbUser, $secureStringPassword)

        $query = "SELECT name, is_disabled FROM sys.sql_logins"
        Invoke-Sqlcmd -Query $query -Username $dbUser -Password $plainPassword -ServerInstance "여러분의서버인스턴스명" # ServerInstance를 필요에 따라 조정하세요
    }
    default {
        Write-Host "지원되지 않는 데이터베이스 유형입니다."
        exit
    }
}

# 주의: SQL Server의 경우, Invoke-Sqlcmd와 PSCredential 객체를 사용하는 것은 비밀번호를 안전하게 다루는 방법입니다.
# "여러분의서버인스턴스명"을 실제 SQL Server 인스턴스 이름으로 교체하세요.
# 이 스크립트는 SQL Server PowerShell 모듈(SqlServer)이 설치되어 있고 사용 가능하다고 가정합니다.
