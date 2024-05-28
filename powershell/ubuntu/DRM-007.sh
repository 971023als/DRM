# 데이터베이스 유형, 사용자 이름, 비밀번호 입력 받기
$DB_TYPE = Read-Host "지원하는 데이터베이스: MySQL, PostgreSQL, MSSQL. 사용할 데이터베이스 유형을 입력하세요"
$DB_USER = Read-Host "$DB_TYPE 사용자 이름"
$DB_PASS = Read-Host "$DB_TYPE 비밀번호" -AsSecureString

# 데이터베이스 유형에 따라 처리
switch ($DB_TYPE) {
    "MySQL" {
        # MySQL 비밀번호 복잡도 검사를 위한 기존 로직
    }
    "PostgreSQL" {
        # PostgreSQL 비밀번호 복잡도 검사를 위한 기존 로직
    }
    "MSSQL" {
        # Invoke-Sqlcmd를 위해 SecureString 비밀번호를 일반 텍스트로 변환
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DB_PASS)
        $PlainTextPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        # MSSQL에서 비밀번호 정책 적용 여부를 확인하기 위한 쿼리 정의
        $Query = @"
SELECT name, is_policy_checked, is_expiration_checked FROM sys.sql_logins
"@

        # 쿼리 실행 및 결과 처리
        try {
            $Results = Invoke-Sqlcmd -Query $Query -Username $DB_USER -Password $PlainTextPass
            foreach ($Result in $Results) {
                if ($Result.is_policy_checked -eq $true) {
                    Write-Host "계정: $($Result.name)에 비밀번호 정책이 적용되었습니다."
                } else {
                    Write-Host "계정: $($Result.name)에 비밀번호 정책이 적용되지 않았습니다."
                }
            }
        } catch {
            Write-Host "MSSQL 데이터베이스 연결 또는 쿼리 실행 중 오류 발생: $_"
        }
    }
    default {
        Write-Host "지원되지 않는 데이터베이스 유형입니다."
    }
}
