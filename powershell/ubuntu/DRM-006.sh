# 데이터베이스 유형, 사용자 이름, 비밀번호 입력 받기
$DB_TYPE = Read-Host "지원하는 데이터베이스: MySQL, PostgreSQL, MSSQL. 사용 중인 데이터베이스 유형을 입력하세요"
$DB_USER = Read-Host "$DB_TYPE 사용자 이름"
$DB_PASS = Read-Host "$DB_TYPE 비밀번호" -AsSecureString

# 데이터베이스 유형에 따라 처리
switch ($DB_TYPE) {
    "MySQL" {
        # MySQL 연결 및 쿼리 실행 로직
    }
    "PostgreSQL" {
        # PostgreSQL은 MySQL처럼 로그인 실패 횟수 제한을 기본적으로 지원하지 않습니다
        # 사용자에게 대체 방법을 안내합니다
    }
    "MSSQL" {
        # SQL Server 연결을 위해 SecureString 비밀번호를 일반 텍스트로 다시 변환
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DB_PASS)
        $PlainTextPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        
        # 로그인 실패 횟수 제한을 확인하기 위한 쿼리 정의
        # MSSQL은 이를 위해 sys.sql_logins 테이블에서 보안 정책을 사용합니다
        $Query = @"
SELECT name, is_disabled, login_failures, is_policy_checked, is_expiration_checked
FROM sys.sql_logins
"@
        
        try {
            # 쿼리 실행
            $Results = Invoke-Sqlcmd -Query $Query -Username $DB_USER -Password $PlainTextPassword -Database "master"
            
            # 결과 처리
            foreach ($Result in $Results) {
                if ($Result.is_policy_checked -eq $true) {
                    Write-Host "계정: $($Result.name)에 로그인 실패 정책이 적용되어 있습니다."
                } else {
                    Write-Host "계정: $($Result.name)에 로그인 실패 정책이 적용되지 않았습니다."
                }
            }
        } catch {
            Write-Host "오류 발생: $_"
        }
    }
    default {
        Write-Host "지원하지 않는 데이터베이스 유형입니다."
    }
}
