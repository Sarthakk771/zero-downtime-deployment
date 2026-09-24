Write-Host "Starting Zero-Downtime Deployment..." -ForegroundColor Cyan

Write-Host "Updating App 1..." -ForegroundColor Yellow

docker stop app1

docker compose up -d --build app1

Write-Host "Waiting for App 1 health check..." -ForegroundColor Yellow

Start-Sleep -Seconds 5

$health1 = Invoke-WebRequest http://localhost:5000/health -UseBasicParsing

if ($health1.StatusCode -eq 200) {
    Write-Host "App 1 is healthy." -ForegroundColor Green
}
else {
    Write-Host "App 1 health check failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Updating App 2..." -ForegroundColor Yellow

docker stop app2

docker compose up -d --build app2

Write-Host "Waiting for App 2 health check..." -ForegroundColor Yellow

Start-Sleep -Seconds 5

$health2 = Invoke-WebRequest http://localhost:5001/health -UseBasicParsing

if ($health2.StatusCode -eq 200) {
    Write-Host "App 2 is healthy." -ForegroundColor Green
}
else {
    Write-Host "App 2 health check failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Deployment completed successfully!" -ForegroundColor Green