# 데이터베이스 자격증명 정의
$DBType = Read-Host "데이터베이스 유형을 입력하세요 (1. MySQL, 2. PostgreSQL, 3. Oracle, 4. SQL Server)"
$DBUser = Read-Host "데이터베이스 사용자 이름을 입력하세요"
$DBPass = Read-Host "데이터베이스 비밀번호를 입력하세요" -AsSecureString
$DBHost = "localhost" # 필요에 따라 업데이트하세요

# SecureString 비밀번호를 일반 텍스트로 변환
$Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DBPass)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Ptr)

function Check-ResourceLimits {
    param (
        [string]$DBType,
        [string]$DBUser,
        [string]$DBPass,
        [string]$DBHost
    )

    switch ($DBType) {
        "1" { # MySQL
            # MySQL에 특화된 연결 및 쿼리 실행 로직
        }
        "2" { # PostgreSQL
            # PostgreSQL에 특화된 연결 및 쿼리 실행 로직
        }
        "3" { # Oracle
            # Oracle에 특화된 연결 및 쿼리 실행 로직
        }
        "4" { # SQL Server
            $ConnectionString = "Data Source=$DBHost;Initial Catalog=master;User ID=$DBUser;Password=$DBPass;"
            $Query = "SELECT value_in_use FROM sys.configurations WHERE name = 'max degree of parallelism';"
            Try {
                $Connection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString
                $Connection.Open()
                $Command = $Connection.CreateCommand()
                $Command.CommandText = $Query
                $Result = $Command.ExecuteScalar()
                Write-Host "SQL Server의 최대 병렬 처리 정도는 다음과 같이 설정됩니다: $Result"
            }
            Catch {
                Write-Host "SQL Server 쿼리 실행 중 오류 발생: $_"
            }
            Finally {
                $Connection.Close()
            }
        }
        default {
            Write-Host "지원되지 않는 데이터베이스 유형입니다."
        }
    }
}

# 자원 제한을 확인하기 위해 함수 호출
Check-ResourceLimits -DBType $DBType -DBUser $DBUser -DBPass $PlainPassword -DBHost $DBHost
