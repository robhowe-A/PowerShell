Add-PSSnapin *Microsoft.SharePoint.PowerShell*
#get the users of sharepoint website:
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