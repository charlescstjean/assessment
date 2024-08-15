# Define the script directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Define the path to PingCastle executable
$pingCastlePath = Join-Path -Path $scriptDir -ChildPath "PingCastle.exe"

# Define the output file path
$outputFile = Join-Path -Path $scriptDir -ChildPath "pingcastle_report.html"

# Define the domain controller (you can modify this to your specific domain controller)
$domainController = "localhost"

# Check if PingCastle executable exists
if (-Not (Test-Path $pingCastlePath)) {
    Write-Host "PingCastle executable not found in the script directory." -ForegroundColor Red
    exit 1
}

# Run PingCastle with an audit command
Write-Host "Running PingCastle audit against domain controller $domainController..."
& $pingCastlePath --audit --server $domainController --output $outputFile

# Check the exit code and report status
if ($LASTEXITCODE -eq 0) {
    Write-Host "PingCastle audit completed successfully. Report saved to $outputFile" -ForegroundColor Green
} else {
    Write-Host "PingCastle audit failed with exit code $LASTEXITCODE" -ForegroundColor Red
}
