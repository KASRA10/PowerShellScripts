# PowerShell با Administrator

# 1. ایجاد Application Pool
New-WebAppPool -Name "VoIPSignalRHub-Test"

# 2. تنظیمات Application Pool
Set-ItemProperty "IIS:\AppPools\VoIPSignalRHub-Test" `
                 -Name "managedRuntimeVersion" -Value "v4.0"
Set-ItemProperty "IIS:\AppPools\VoIPSignalRHub-Test" `
                 -Name "processModel.idleTimeout" -Value "00:00:00"

# 3. ایجاد Application در Default Web Site
#    توجه: مسیر باید دقیقاً مطابق پوشه Publish تو باشد
$publishPath = "D:\Kasra10\Codes\CSharp-APPs\SAYA\VoIP Module\TestBasics\VoIPTestUnitApp\VoIPSignalRHub\bin\app.publish"

New-WebApplication -Site "Default Web Site" `
                   -Name "VoIPSignalRHub" `
                   -PhysicalPath $publishPath `
                   -ApplicationPool "VoIPSignalRHub-Test"

# 4. تنظیم Permission برای مسیر واقعی تو
icacls $publishPath /grant "IIS AppPool\VoIPSignalRHub-Test":(OI)(CI)(RX)

# 5. همچنین برای IIS_IUSRS هم Permission بده (برای اطمینان)
icacls $publishPath /grant "IIS_IUSRS":(OI)(CI)(RX)