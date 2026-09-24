param(
    [string]$NewVersion = "3.0",
    [string]$PreviousVersion = "2.0"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Zero-Downtime Deployment Platform" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

function Check-Health {
    param(
        [string]$Url,
        [string]$AppName
    )

    Write-Host "Checking $AppName health..." -ForegroundColor Yellow

    Start-Sleep -Seconds 5

    try {
        $response = Invoke-WebRequest $Url -UseBasicParsing -TimeoutSec 5

        if ($response.StatusCode -eq 200) {
            Write-Host "$AppName is healthy." -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Host "$AppName health check failed." -ForegroundColor Red
        return $false
    }

    return $false
}

function Set-Version {
    param(
        [string]$Version
    )

    Write-Host "Setting application version to $Version..." -ForegroundColor Yellow

    (Get-Content docker-compose.yml) `
        -replace 'VERSION: "[0-9]+\.[0-9]+"', "VERSION: `"$Version`"" |
        Set-Content docker-compose.yml
}

Write-Host "Deploying Version $NewVersion..." -ForegroundColor Cyan

# Update App 1
Write-Host "`nUpdating App 1..." -ForegroundColor Yellow

Set-Version $NewVersion

docker compose up -d --no-deps app1

$app1Healthy = Check-Health "http://localhost:5000/health" "App 1"

if (-not $app1Healthy) {
    Write-Host "`nApp 1 deployment failed!" -ForegroundColor Red
    Write-Host "Rolling back to Version $PreviousVersion..." -ForegroundColor Yellow

    Set-Version $PreviousVersion
    docker compose up -d --no-deps app1

    Write-Host "App 1 rollback completed." -ForegroundColor Green
    exit 1
}

# Update App 2
Write-Host "`nUpdating App 2..." -ForegroundColor Yellow

docker compose up -d --no-deps app2

if (-not (Check-Health "http://localhost:5001/health" "App 2")) {

    Write-Host "`nApp 2 deployment failed!" -ForegroundColor Red
    Write-Host "Rolling back to Version $PreviousVersion..." -ForegroundColor Yellow

    Set-Version $PreviousVersion

    docker compose up -d --no-deps app1
    docker compose up -d --no-deps app2

    Write-Host "Rollback completed successfully." -ForegroundColor Green
    exit 1
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host " Deployment completed successfully!" -ForegroundColor Green
Write-Host " Version: $NewVersion" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green