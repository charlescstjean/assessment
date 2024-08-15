# Define the script directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Define the path to PingCastle executable
$pingCastlePath = Join-Path -Path $scriptDir -ChildPath "PingCastle.exe"

# Define the domain controller (you can use "localhost" for local scan)
$domainController = "localhost"

# Get the domain name for the output file name
try {
    $domainName = (Get-ADDomain).DNSRoot
} catch {
    Write-Host "Failed to retrieve domain information. Ensure this script is run on a domain-joined machine with necessary permissions." -ForegroundColor Red
    exit 1
}

# Sanitize domain name to be a valid file name
$domainName = $domainName -replace '[\/:*?"<>|]', '_'

# Define the output file path
$outputFile = Join-Path -Path $scriptDir -ChildPath "$domainName.html"

# Check if PingCastle executable exists
if (-Not (Test-Path $pingCastlePath)) {
    Write-Host "PingCastle executable not found in the script directory." -ForegroundColor Red
    exit 1
}

# Run PingCastle with a health check command
Write-Host "Running PingCastle health check against domain controller $domainController..."
& $pingCastlePath --healthcheck --server $domainController --output $outputFile

# Check the exit code and report status
if ($LASTEXITCODE -eq 0) {
    Write-Host "PingCastle health check completed successfully. Report saved to $outputFile" -ForegroundColor Green
} else {
    Write-Host "PingCastle health check failed with exit code $LASTEXITCODE" -ForegroundColor Red
}
