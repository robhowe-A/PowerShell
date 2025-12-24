<#
#Description: This script writes SharePoint Server user properties to output text file
#Author: Robert Howell
#Date: 09/2024
#Notes: 
    -get the users of sharepoint website:
#>
Add-PSSnapin *Microsoft.SharePoint.PowerShell*
$url = "http://developer.hyperspace.local:5001"

#set the output file path
#$env:USERPROFILE is the local user, so user\documents\<filename>.txt
$outFilePath = "$($env:USERPROFILE)\documents\webUsers.txt"

function getWebUsers($url) {
    $web = get-spweb -Identity $url
    if ($web){
        Get-SPUser -Web $web |`
            select name, userlogin, sid, groups | `
            Out-File -FilePath $outFilePath
    }
}
getWebUsers $url
ii $outFilePath