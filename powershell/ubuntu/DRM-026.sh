# SSH를 통해 원격 명령을 실행하는 함수 정의 (자리 표시자, 상황에 맞게 조정)
function Invoke-SSHCommand {
    param (
        [string]$Server,
        [string]$Username,
        [string]$Password, # 생산 환경에서는 SecureString과 보다 안전한 방법을 고려하세요
        [string]$Command
    )
    # SSH 명령 실행을 위한 자리 표시자
    # 여러분의 실제 SSH 실행 코드로 이 부분을 대체하세요. 예를 들어, Posh-SSH 또는 유사한 것을 사용
    Write-Host "$Server 에 SSH 명령을 실행합니다"
}

# 메인 스크립트
Write-Host "지원되는 데이터베이스: 1. MySQL 2. PostgreSQL 3. Oracle"
$DBType = Read-Host "데이터베이스 유형 번호를 입력하세요"

# DB 유형에 따라 데이터베이스 서비스 계정 설정
$DatabaseServiceAccount = switch ($DBType) {
    "1" { "mysql" }
    "2" { "postgres" }
    "3" { "oracle" }
    default {
        Write-Host "지원되지 않는 데이터베이스 유형입니다."
        exit
    }
}

$ExpectedUmask = "027"

# 간단함을 위해 원격 Linux/Unix 환경을 가정
$Server = Read-Host "서버 주소를 입력하세요"
$Username = Read-Host "SSH 사용자 이름을 입력하세요"
$Password = Read-Host "SSH 비밀번호를 입력하세요" # 생산 환경에서는 SecureString을 고려하세요

# umask 값 확인을 위한 명령
$Command = "su - $DatabaseServiceAccount -c umask"

# 원격 명령 실행
$UmaskValue = Invoke-SSHCommand -Server $Server -Username $Username -Password $Password -Command $Command

if ($UmaskValue -eq $ExpectedUmask) {
    Write-Host "데이터베이스 서비스 계정($DatabaseServiceAccount)은 올바른 umask 값을 가지고 있습니다 ($ExpectedUmask)."
} else {
    Write-Host "데이터베이스 서비스 계정($DatabaseServiceAccount)의 umask 값($UmaskValue)이 예상치($ExpectedUmask)에 부합하지 않습니다."
}
