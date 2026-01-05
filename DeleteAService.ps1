param(
    [Parameter(Mandatory = $true)]
    [string]$ServiceName
)

Write-Host "Processing service: $ServiceName"

# 1. Check if service exists
$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if (-not $service) {
    Write-Host "Service '$ServiceName' does not exist."
    return
}

# 2. Stop dependent services first
Write-Host "Stopping dependent services..."
$dependentServices = (Get-Service -Name $ServiceName).DependentServices
foreach ($dep in $dependentServices) {
    Write-Host "Stopping dependent service: $($dep.Name)"
    Stop-Service -Name $dep.Name -Force -ErrorAction SilentlyContinue
}

# 3. Stop the main service
Write-Host "Stopping main service..."
Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue

Start-Sleep -Seconds 1

# 4. Kill the underlying process if still running
Write-Host "Checking for running processes..."
$serviceConfig = sc.exe qc $ServiceName | Select-String "BINARY_PATH_NAME"
$exePath = $serviceConfig.ToString().Split(":", 2)[1].Trim()

# Extract EXE name
$exeName = Split-Path $exePath -Leaf

if ($exeName) {
    $proc = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $exePath }
    if ($proc) {
        Write-Host "Killing process: $exeName"
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    }
}

Start-Sleep -Seconds 1

# 5. Delete the service
Write-Host "Deleting service..."
sc.exe delete $ServiceName | Out-Null

Write-Host "Service '$ServiceName' deletion requested."

# 6. Verify deletion
Start-Sleep -Seconds 1
$check = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($check) {
    Write-Host "Service is marked for deletion. A reboot may be required if SCM still holds a handle."
}
else {
    Write-Host "Service '$ServiceName' fully removed."
}
