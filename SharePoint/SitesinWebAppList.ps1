<#
#Description: This script outputs SharePoint Server web application properties
#Author: Robert Howell
#Date: 09/2024
#Notes: 
    -list web applications and the site URLs
    -list each site collection url in the web application
#>
$was = Get-SPWebApplications
if ($was -ne $null) {
    #list each web application and the name
    foreach ($wa in $was){
        Write-Host "Web App:"` -NoNewline
        Write-Host " $($wa) "` -ForegroundColor Green
    
        #list each site collection url in the web application
        if ($wa.Sites.Count -gt 0){
            foreach($site in $wa.Sites){
                Write-Host " Site: "` -ForegroundColor Gray -NoNewline
                Write-Host " $($site.url.toString())`n"
            }
        }
        else {
            Write-Host "No sites in Web Application: " -NoNewline -ForeGroundColor DarkCyan
            Write-Host "$($wa.Name), $($wa.Url)" -ForegroundColor Cyan
        }
    }
}
else{
    Write-Host "No web applications found. =" -ForegroundColor Yellow -NoNewline
    Write-Host $_
}