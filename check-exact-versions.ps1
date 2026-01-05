# check-exact-versions.ps1
$publishPath = "D:\Kasra10\Codes\CSharp-APPs\SAYA\VoIP Module\TestBasics\VoIPTestUnitApp\VoIPSignalRHub\bin\app.publish\bin"

Write-Host "=== Checking Exact DLL Versions ===" -ForegroundColor Cyan

$dllsToCheck = @(
    "Microsoft.Owin.dll",
    "Microsoft.Owin.Host.SystemWeb.dll",
    "Microsoft.Owin.Security.dll",
    "Microsoft.AspNet.SignalR.Core.dll",
    "Newtonsoft.Json.dll",
    "Microsoft.Owin.Cors.dll"
)

foreach ($dll in $dllsToCheck) {
    $fullPath = Join-Path $publishPath $dll
    if (Test-Path $fullPath) {
        try {
            $assembly = [Reflection.AssemblyName]::GetAssemblyName($fullPath)
            Write-Host "✅ $($assembly.Name)" -ForegroundColor Green -NoNewline
            Write-Host " - Version: $($assembly.Version)" -ForegroundColor Yellow
            Write-Host "   PublicKeyToken: $($assembly.GetPublicKeyToken() | ForEach-Object {$_.ToString("x2")})" -ForegroundColor Gray
        }
        catch {
            Write-Host "⚠️ $dll - Could not read version" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "❌ $dll - NOT FOUND" -ForegroundColor Red
    }
}

Write-Host "`n=== Generating web.config binding redirects ===" -ForegroundColor Cyan
Write-Host '<runtime>' -ForegroundColor Magenta
Write-Host '  <assemblyBinding xmlns="urn:schemas-microsoft-com:asm:v1">' -ForegroundColor Magenta

foreach ($dll in $dllsToCheck) {
    $fullPath = Join-Path $publishPath $dll
    if (Test-Path $fullPath) {
        try {
            $assembly = [Reflection.AssemblyName]::GetAssemblyName($fullPath)
            $name = $assembly.Name
            $version = $assembly.Version
            $publicKeyToken = ($assembly.GetPublicKeyToken() | ForEach-Object { $_.ToString("x2") }) -join ''
            
            Write-Host "    <dependentAssembly>" -ForegroundColor Gray
            Write-Host "      <assemblyIdentity name=`"$name`" publicKeyToken=`"$publicKeyToken`" culture=`"neutral`" />" -ForegroundColor White
            Write-Host "      <bindingRedirect oldVersion=`"0.0.0.0-$version`" newVersion=`"$version`" />" -ForegroundColor Green
            Write-Host "    </dependentAssembly>" -ForegroundColor Gray
        }
        catch { }
    }
}

Write-Host '  </assemblyBinding>' -ForegroundColor Magenta
Write-Host '</runtime>' -ForegroundColor Magenta