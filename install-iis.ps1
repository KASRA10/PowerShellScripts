# install-iis.ps1
Write-Host "🔧 Installing IIS on Windows 10/11..." -ForegroundColor Cyan

# لیست ویژگی‌های مورد نیاز
$features = @(
    "IIS-WebServerRole",
    "IIS-WebServer",
    "IIS-CommonHttpFeatures",
    "IIS-StaticContent",
    "IIS-DefaultDocument",
    "IIS-DirectoryBrowsing",
    "IIS-HttpErrors",
    "IIS-ApplicationDevelopment",
    "IIS-ASPNET45",
    "IIS-NetFxExtensibility45",
    "IIS-ISAPIExtensions",
    "IIS-ISAPIFilter",
    "IIS-WebSockets",
    "IIS-ManagementConsole",
    "IIS-ManagementScriptingTools",
    "IIS-ManagementService",
    "NetFx4Extended-ASPNET45",
    "IIS-HttpCompressionDynamic",
    "IIS-HttpLogging"
)

Write-Host "Installing features..." -ForegroundColor Yellow

foreach ($feature in $features) {
    Write-Host "  - $feature" -ForegroundColor Gray
    Enable-WindowsOptionalFeature -Online -FeatureName $feature -NoRestart -ErrorAction SilentlyContinue | Out-Null
}

Write-Host "✅ IIS installation completed!" -ForegroundColor Green
Write-Host "🔄 Please restart your computer to complete the installation." -ForegroundColor Yellow