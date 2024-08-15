# Define the script directory
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Define the path to PingCastle executable
$pingCastlePath = Join-Path -Path $scriptDir -ChildPath "PingCastle.exe"

# Run systeminfo and filter for the "Domain" line
$systemInfoOutput = & systeminfo | findstr /C:"Domain"

# Extract the domain name from the output
if ($systemInfoOutput) {
    # Split the output line and get the domain name part
    $domainName = $systemInfoOutput -replace "Domain:\s*", ""

    # Trim any extra whitespace
    $domainName = $domainName.Trim()

    # Check if domain name is empty
    if ($domainName) {
        Write-Host "Domain Name: $domainName" -ForegroundColor Green

        # Check if PingCastle executable exists
        if (-Not (Test-Path $pingCastlePath)) {
            Write-Host "PingCastle executable not found in the script directory." -ForegroundColor Red
            exit 1
        }

        # Run PingCastle with a health check command
        Write-Host "Running PingCastle health check on domain $domainName..."
        try {
            & $pingCastlePath --healthcheck --server $domainName
        } catch {
            Write-Host "Failed to run PingCastle command. Check for details." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Domain information is not available." -ForegroundColor Red
    }
} else {
    Write-Host "Failed to retrieve domain information using systeminfo." -ForegroundColor Red
}
