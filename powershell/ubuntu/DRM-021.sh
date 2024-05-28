# 필요한 ODBC 데이터 소스 및 OLE-DB 드라이버 목록 정의
$necessarySources = @("필요한_소스_1", "필요한_소스_2") # 여러분의 요구사항에 맞게 이 목록을 업데이트하세요

# ODBC 데이터 소스 목록 가져오기
$odbcSources = & odbcconf.exe /q | Select-String "DSN=" | ForEach-Object { $_.ToString().Split("=")[1].Trim() }

# 필요하지 않은 ODBC 데이터 소스 검사
Write-Host "필요하지 않은 ODBC 데이터 소스를 검사 중..."
foreach ($source in $odbcSources) {
    if ($necessarySources -notcontains $source) {
        Write-Host "필요하지 않은 ODBC 데이터 소스 발견: $source"
    }
}

# OLE-DB 드라이버 목록 가져오기 (예시는 COM 객체를 사용함, 환경에 맞게 조정 필요)
try {
    $oleDbProviders = New-Object System.Data.OleDb.OleDbEnumerator
    $data = $oleDbProviders.GetElements()
    $oleDbDrivers = $data | Select-Object SOURCES_NAME | ForEach-Object { $_.SOURCES_NAME }
} catch {
    Write-Host "OLE-DB 드라이버 열거 중 오류 발생."
    $oleDbDrivers = @()
}

# 필요하지 않은 OLE-DB 드라이버 검사
Write-Host "필요하지 않은 OLE-DB 드라이버를 검사 중..."
foreach ($driver in $oleDbDrivers) {
    if ($necessarySources -notcontains $driver) {
        Write-Host "필요하지 않은 OLE-DB 드라이버 발견: $driver"
    }
}

# 참고: 이 스크립트는 필요한 데이터 소스와 드라이버의 사전 정의된 목록을 가정합니다.
# 스크립트를 여러분의 환경 요구사항에 맞게 조정하세요.
