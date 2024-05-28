# MySQL, Oracle, PostgreSQL, 및 SQL Server에 대한 중요 파일 목록 정의
# 환경에 따라 경로를 조정하세요
$filesToCheck = @{
    "1" = "C:\ProgramData\MySQL\MySQL Server X.X\my.ini" # MySQL 버전을 X.X로 업데이트하세요
    "2" = "C:\app\oracle\product\11.2.0\dbhome_1\network\admin\listener.ora"
    "3" = "C:\Program Files\PostgreSQL\X.X\data\postgresql.conf" # PostgreSQL 버전을 X.X로 업데이트하세요
    "4" = "C:\Program Files\Microsoft SQL Server\MSSQLXX.MSSQLSERVER\MSSQL\Binn\sqlservr.ini" # SQL Server 버전을 XX로 업데이트하세요
}

# 사용자에게 데이터베이스 선택 요청
Write-Host "지원되는 데이터베이스: 1. MySQL 2. Oracle 3. PostgreSQL 4. SQL Server"
$DB_CHOICE = Read-Host "데이터베이스 번호를 입력하세요"

if (-not $filesToCheck.ContainsKey($DB_CHOICE)) {
    Write-Host "잘못된 선택입니다."
    exit
}

# 사용자 선택에 따라 파일을 확인
$fileToCheck = $filesToCheck[$DB_CHOICE]

# 파일 존재 여부 확인
if (Test-Path $fileToCheck) {
    # 파일 ACL 가져오기
    $fileACL = Get-Acl $fileToCheck
    $ownerPermissions = $fileACL.Access | Where-Object { $_.FileSystemRights -match "FullControl|Modify|ReadAndExecute|Read|Write" -and $_.IdentityReference -eq $fileACL.Owner }

    # 소유자에게만 "읽기 및 쓰기"보다 더 허용적인 권한이 설정되어 있는지 확인
    if ($ownerPermissions -ne $null -and $ownerPermissions.Count -gt 1) {
        Write-Host "파일 $fileToCheck의 권한이 불안전합니다: $($ownerPermissions.FileSystemRights)"
    } else {
        Write-Host "파일 $fileToCheck의 권한이 안전합니다."
    }
} else {
    Write-Host "파일 $fileToCheck가 존재하지 않습니다"
}
