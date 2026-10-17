# Run once on the IIS server in an ELEVATED PowerShell.
param([int]$Port = 8080)

Install-WindowsFeature -Name Web-Server, Web-Mgmt-Tools, Web-Scripting-Tools -IncludeManagementTools

# .NET 8 Hosting Bundle (must be installed AFTER IIS)
$installer = "$env:TEMP\dotnet-hosting-8.exe"
Invoke-WebRequest "https://aka.ms/dotnet/8.0/dotnet-hosting-win.exe" -OutFile $installer
Start-Process $installer -ArgumentList "/install /quiet /norestart" -Wait

net stop was /y
net start w3svc

New-NetFirewallRule -DisplayName "SimpleWeb $Port" -Direction Inbound -Protocol TCP `
    -LocalPort $Port -Action Allow -ErrorAction SilentlyContinue

New-Item -ItemType Directory -Force -Path "C:\inetpub\wwwroot\SimpleWeb" | Out-Null
Write-Host "IIS ready. Now register this server in Azure DevOps (Pipelines > Environments > IIS-Lab)."
