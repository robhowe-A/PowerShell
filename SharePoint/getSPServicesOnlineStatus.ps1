<#
#Description: This script outputs SharePoint Server services online status
#Author: Robert Howell
#Date: 09/2024
#>
Add-PSSnapin *Microsoft.SharePoint.PowerShell* -ErrorAction SilentlyContinue

function checkSPServices(){
    $services = Get-SPService

    foreach ($svc in $services){
        if ($svc.status -ne "Online"){
            Write-Host "-----------------------------------`
                Services Offline: " -ForegroundColor Red
            Write-Host "Service: " -ForegroundColor Yellow -NoNewline
            Write-Host $svc.typename  -ForegroundColor Gray -NoNewline
            Write-Host " status is " -ForegroundColor Yellow -NoNewline
            Write-Host $svc.status -ForegroundColor DarkYellow
        }
        else {
            
            Write-Host "Service: " -ForegroundColor Gray -NoNewline
            Write-Host $svc.typename  -ForegroundColor Magenta -NoNewline
            Write-Host " status is " -ForegroundColor Gray -NoNewline
            Write-Host $svc.status -ForegroundColor Green
        }
    }
}
checkSPServices