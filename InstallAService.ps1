param(
    [Parameter(Mandatory = $true)]
    [string]$ServiceName,

    [Parameter(Mandatory = $true)]
    [string]$DisplayName,

    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$ExecutablePath,

    [string]$StartupType = "Automatic",

    [string]$Description = ""
)

if (-not (Test-Path $ExecutablePath)) {
    Write-Error "Executable file not found: $ExecutablePath"
    exit 1
}

$binPath = "`"$ExecutablePath`""

$existing = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($existing) {
    Write-Host "Service '$ServiceName' already exists. Stopping and updating..." -ForegroundColor Yellow
    Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
    
    sc.exe config $ServiceName binPath= $binPath | Out-Null
    
    if ($Description) {
        sc.exe description $ServiceName $Description | Out-Null
    }
}
else {
    Write-Host "Creating new service '$ServiceName'..." -ForegroundColor Green
    
    if ($Description) {
        New-Service -Name $ServiceName `
            -BinaryPathName $binPath `
            -DisplayName $DisplayName `
            -StartupType $StartupType `
            -Description $Description
    }
    else {
        New-Service -Name $ServiceName `
            -BinaryPathName $binPath `
            -DisplayName $DisplayName `
            -StartupType $StartupType
    }
}

sc.exe failure $ServiceName reset= 86400 actions= restart/5000/restart/5000/restart/5000 | Out-Null

Write-Host "Starting service '$ServiceName'..." -ForegroundColor Cyan
Start-Service -Name $ServiceName

Write-Host "Service '$ServiceName' installed and started successfully!" -ForegroundColor Green
Write-Host "Executable: $ExecutablePath" -ForegroundColor Gray