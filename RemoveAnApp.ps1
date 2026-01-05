# PowerShell Script to Completely Remove VoIPTestUnitApp
# WARNING: Run this script as Administrator. This can permanently delete files and registry entries.
# Backup important data before running. Use at your own risk - this may affect system stability if the app is critical.
# This script attempts to:
# 1. Uninstall the application via WMI (may be slow).
# 2. Stop and delete related services.
# 3. Remove shortcuts from Desktop and Start Menu (for all users and current user).
# 4. Remove from Startup folders and registry run keys.

# Define the app name pattern (use wildcards if exact name varies)
$appName = "VoIPTestUnitApp"

# Step 1: Uninstall the application
Write-Host "Uninstalling $appName..."
$installedApps = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*$appName*" }
if ($installedApps) {
    foreach ($app in $installedApps) {
        $app.Uninstall() | Out-Null
        Write-Host "Uninstalled: $($app.Name)"
    }
}
else {
    Write-Host "No installed app matching $appName found via WMI."
}

# Alternative uninstall if above fails: Check registry for uninstall strings
$uninstallKeys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)
foreach ($key in $uninstallKeys) {
    Get-ChildItem -Path $key | ForEach-Object {
        $props = Get-ItemProperty $_.PSPath
        if ($props.DisplayName -like "*$appName*") {
            $uninstallString = $props.UninstallString
            if ($uninstallString) {
                Write-Host "Running uninstaller for: $($props.DisplayName)"
                # Execute the uninstall string (may need to handle MSI vs EXE)
                if ($uninstallString -match "msiexec") {
                    Start-Process "msiexec.exe" -ArgumentList ($uninstallString -replace "/I", "/X") + " /qn" -Wait
                }
                else {
                    Start-Process $uninstallString -ArgumentList "/S" -Wait  # Assume silent uninstall
                }
            }
        }
    }
}

# Step 2: Stop and delete related services
Write-Host "Handling services for $appName..."
$services = Get-Service | Where-Object { $_.DisplayName -like "*$appName*" -or $_.Name -like "*$appName*" }
if ($services) {
    foreach ($service in $services) {
        Write-Host "Stopping service: $($service.Name)"
        Stop-Service -Name $service.Name -Force -ErrorAction SilentlyContinue
        Write-Host "Deleting service: $($service.Name)"
        sc.exe delete $service.Name | Out-Null
    }
}
else {
    Write-Host "No services matching $appName found."
}

# Step 3: Remove shortcuts from Desktop and Start Menu
Write-Host "Removing shortcuts..."
$shortcutPaths = @(
    "$env:USERPROFILE\Desktop\*$appName*.lnk",
    "$env:ALLUSERSPROFILE\Desktop\*$appName*.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\*$appName*.lnk",
    "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\*$appName*.lnk"
)
foreach ($path in $shortcutPaths) {
    Remove-Item -Path $path -Force -ErrorAction SilentlyContinue
}

# Step 4: Remove from Startup (folders and registry)
Write-Host "Removing from startup..."
# Startup folders
$startupFolders = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\*$appName*.lnk",
    "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Startup\*$appName*.lnk"
)
foreach ($folder in $startupFolders) {
    Remove-Item -Path $folder -Force -ErrorAction SilentlyContinue
}

# Registry run keys
$runKeys = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
)
foreach ($key in $runKeys) {
    Get-ItemProperty -Path $key | ForEach-Object {
        $props = $_
        $props.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' -and $_.Value -like "*$appName*" } | ForEach-Object {
            Remove-ItemProperty -Path $key -Name $_.Name -Force
            Write-Host "Removed startup entry: $($_.Name)"
        }
    }
}

Write-Host "Removal process completed. Restart your computer to ensure all changes take effect."
Write-Host "Note: This may not remove all residual files (e.g., in Program Files or AppData). Manually check and delete folders like C:\Program Files\$appName if needed."