# SimpleWeb - Azure DevOps to IIS Lab

ASP.NET Core 8 Razor Pages site, built and deployed to a Windows IIS server with Azure DevOps.

## Layout
```
azure-pipelines.yml        CI/CD pipeline (build -> artifact -> deploy to IIS)
scripts/setup-iis.ps1      One-time IIS + Hosting Bundle setup on the server
src/SimpleWeb/             The web app
```

## Run locally
```powershell
dotnet restore src/SimpleWeb/SimpleWeb.csproj
dotnet build   src/SimpleWeb/SimpleWeb.csproj -c Release
dotnet run --project src/SimpleWeb/SimpleWeb.csproj
```

## Build the deployable package manually
```powershell
dotnet publish src/SimpleWeb/SimpleWeb.csproj -c Release -o ./publish
```
`./publish` (with its generated `web.config`) is what IIS serves.

## Lab steps
1. On the IIS server (elevated PowerShell): `.\scripts\setup-iis.ps1`
2. Azure DevOps > Pipelines > Environments > New > `IIS-Lab` > Virtual machines > Add resource > Windows. Run the generated script on the server.
3. Push this repo, then Pipelines > New pipeline > Existing Azure Pipelines YAML > `azure-pipelines.yml`.
4. Browse to `http://<server-ip>:8080` and `http://<server-ip>:8080/health`.

## Troubleshooting
- HTTP 500.19 / 500.0: Hosting Bundle missing or installed before IIS. Reinstall, then `iisreset`.
- App pool must be **No Managed Code**.
- Task not found: install the "IIS Web App Deployment Using WinRM" extension in your org.
