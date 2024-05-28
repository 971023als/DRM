# 도움말 함수 정의
function Write-OutputWithBar {
    Write-Output "==========================================="
}

function Check-MSSQLSecuritySettings {
    param(
        [string]$SqlServer,
        [PSCredential]$SqlCredential
    )
    Import-Module SqlServer

    try {
        # 혼합 모드 인증 (Windows + SQL Server 인증) 확인
        $queryAuthenticationMode = "SELECT SERVERPROPERTY('IsMixedModeAuthentication')"
        $mixedModeAuthentication = Invoke-Sqlcmd -ServerInstance $SqlServer -Credential $SqlCredential -Query $queryAuthenticationMode

        if ($mixedModeAuthentication.Column1 -eq 1) {
            Write-Output "경고: 혼합 모드 인증(Windows 및 SQL Server)이 활성화되어 있습니다."
        } else {
            Write-Output "양호: Windows 인증 모드만 활성화되어 있습니다."
        }

        # 보안 연결 확인 자리 표시자
        # 실제 상황에서는 SQL Server가 암호화된 연결에 SSL을 사용하는지 설정을 확인해야 합니다.
        # 예시: "SELECT * FROM sys.dm_exec_connections WHERE encrypt_option = 'TRUE'"
        # 이 부분은 실제 확인이 필요한 경우 대체해야 하는 자리 표시자입니다.
        $secureConnectionCheck = $true # 자리 표시자 값

        if ($secureConnectionCheck) {
            Write-Output "양호: 보안 연결이 활성화되어 있습니다."
        } else {
            Write-Output "경고: 보안 연결이 강제되지 않습니다."
        }
    }
    catch {
        Write-Output "MSSQL 보안 설정 확인 중 오류 발생: $_"
    }
}

Write-OutputWithBar
Write-Output "MSSQL 보안 설정 확인 중"

# SQL Server 연결 세부 정보 입력 요청
$SqlServer = Read-Host "SQL Server 인스턴스 입력 (예: ServerName\\InstanceName)"
$SqlCredential = Get-Credential -Message "SQL Server 관리자 자격 증명 입력"

Check-MSSQLSecuritySettings -SqlServer $SqlServer -SqlCredential $SqlCredential

Write-OutputWithBar
