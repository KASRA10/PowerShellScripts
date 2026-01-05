param(
    [Parameter(Mandatory = $true)]
    [string]$ServiceName,

    [Parameter(Mandatory = $true)]
    [string]$DisplayName,

    [Parameter(Mandatory = $true)]
    [string]$ExecutablePath,

    [string]$StartupType = "Automatic"
)

# Build proper quoted binPath
$binPath = "`"$ExecutablePath`""

# Check if service exists
$existing = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "Service '$ServiceName' already exists. Updating executable path..."
    sc.exe config $ServiceName binPath= $binPath | Out-Null
}
else {
    Write-Host "Creating service '$ServiceName'..."
    New-Service -Name $ServiceName `
        -BinaryPathName $binPath `
        -DisplayName $DisplayName `
        -StartupType $StartupType
}

# Start service
Write-Host "Starting service..."
Start-Service -Name $ServiceName

Write-Host "Service '$ServiceName' installed and started successfully."
