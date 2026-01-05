# PowerShell as Administrator

# 1. Create Application Pool
New-WebAppPool -Name "SampleAppPool"

# 2. Configure Application Pool
Set-ItemProperty "IIS:\AppPools\SampleAppPool" `
    -Name "managedRuntimeVersion" -Value "v4.0"
Set-ItemProperty "IIS:\AppPools\SampleAppPool" `
    -Name "processModel.idleTimeout" -Value "00:00:00"

# 3. Create Application in Default Web Site
#    Note: The path must exactly match your Publish folder
$publishPath = "D:\Projects\SampleApp\PublishOutput"

New-WebApplication -Site "Default Web Site" `
    -Name "SampleWebApp" `
    -PhysicalPath $publishPath `
    -ApplicationPool "SampleAppPool"

# 4. Set permissions for your actual path
icacls $publishPath /grant "IIS AppPool\SampleAppPool":(OI)(CI)(RX)

# 5. Also grant permissions to IIS_IUSRS (for safety)
icacls $publishPath /grant "IIS_IUSRS":(OI)(CI)(RX)
