# Define helper functions
function Write-Bar {
    Write-Host "============================================"
}

function Write-Code {
    param($code)
    Write-Host "CODE [$code]"
}

function Warn {
    param($message)
    Write-Host "WARNING: $message"
}

function OK {
    param($message)
    Write-Host "OK: $message"
}

# Start of the script
Write-Bar
Write-Code "DBM-011] 감사 로그 수집 및 백업 미흡"

# User input for database type
$DB_TYPE = Read-Host "지원하는 데이터베이스: MySQL, PostgreSQL, Oracle, MSSQL. 사용 중인 데이터베이스 유형을 입력하세요"

# Setting audit log directory based on database type
$audit_log_dir = switch ($DB_TYPE) {
    "MySQL" { "C:\ProgramData\MySQL\MySQL Server*\Data\*.log" } # Example path, adjust as necessary
    "PostgreSQL" { "C:\Program Files\PostgreSQL*\data\log\*.log" } # Example path, adjust as necessary
    "Oracle" { "C:\app\*\oradata\*\*.log" } # Example path, adjust as necessary
    "MSSQL" { "C:\Program Files\Microsoft SQL Server\MSSQL*\MSSQL\Log\*.trc" } # Example path, adjust as necessary for SQL Server trace files or audit logs
    default { Write-Host "지원하지 않는 데이터베이스 유형입니다."; exit }
}

# Check if audit logs are being collected
$auditLogsExist = Test-Path $audit_log_dir
if ($auditLogsExist) {
    OK "감사 로그가 정기적으로 수집되고 있습니다."
} else {
    Warn "감사 로그가 수집되지 않고 있습니다."
}

# Backup directory
$backup_dir = "C:\Backups\Audit" # Adjust as necessary

# Check for recent backup files
$recentBackupExists = Get-ChildItem $backup_dir -Filter "*.bak" | Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-30) }
if ($recentBackupExists) {
    OK "감사 로그가 최근 30일 이내에 백업되었습니다."
} else {
    Warn "감사 로그 백업이 30일 이상 되지 않았습니다."
}

Write-Bar
