function Invoke-SqlQuery {
    param (
        [string]$ServerInstance,
        [string]$Database,
        [PSCredential]$Credential,
        [string]$Query
    )
    $ConnectionString = "Server=$ServerInstance; Database=$Database; Integrated Security=True;"
    if ($Credential) {
        $ConnectionString = "Server=$ServerInstance; Database=$Database; User ID=$($Credential.UserName); Password=$($Credential.GetNetworkCredential().Password);"
    }
    $Connection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString
    $Command = $Connection.CreateCommand()
    $Command.CommandText = $Query
    $Connection.Open()
    $Result = $Command.ExecuteScalar()
    $Connection.Close()
    return $Result
}

function Check-PublicRolePrivileges {
    param (
        [string]$DBType,
        [string]$ServerInstance,
        [PSCredential]$Credential = $null,
        [string]$Database = "master"
    )

    if ($DBType -eq "MSSQL") {
        $QueryDatabaseLevel = "SELECT COUNT(*) FROM sys.database_permissions WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID('public')"
        $QueryServerLevel = "SELECT COUNT(*) FROM sys.server_permissions WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID('public')"
        $DatabaseLevelPrivileges = Invoke-SqlQuery -ServerInstance $ServerInstance -Database $Database -Credential $Credential -Query $QueryDatabaseLevel
        $ServerLevelPrivileges = Invoke-SqlQuery -ServerInstance $ServerInstance -Database $Database -Credential $Credential -Query $QueryServerLevel
        
        if ($DatabaseLevelPrivileges -eq 0 -and $ServerLevelPrivileges -eq 0) {
            Write-Host "양호: 데이터베이스 및 서버 레벨에서 PUBLIC 역할에 부여된 불필요한 권한이 없습니다."
        } else {
            Write-Host "경고: PUBLIC 역할에 불필요한 권한이 부여되었습니다. 데이터베이스 및 서버 레벨 권한을 검토해 주세요."
        }
    } else {
        Write-Host "이 스크립트에서 지원하지 않는 데이터베이스 유형입니다."
    }
}

# 메인 스크립트 시작
$DBType = Read-Host "사용 중인 데이터베이스 유형을 입력하세요 (MSSQL)"
$ServerInstance = Read-Host "SQL Server 인스턴스를 입력하세요 (예: ServerName\\InstanceName)"
$Credential = Get-Credential -Message "SQL Server 관리자 자격 증명을 입력하세요"

Check-PublicRolePrivileges -DBType $DBType -ServerInstance $ServerInstance -Credential $Credential
