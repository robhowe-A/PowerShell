$user = "CN=SharePoint Farm Administrator,OU=SharePoint,DC=hyperspace,DC=local" #user by SamAccountName, DistinguishedName, GUID, or SID
$outFilePath = "$($env:USERPROFILE)\documents\user.txt"

function getADUser($user, $outFilePath){
    try{
        $user = get-aduser -id $user -Properties * |`
            select *
        if($user){
            $user | Out-File -FilePath $outFilePath
        }
    }
    catch {Write-Host "No user found. Error: $($_)" -ForegroundColor Yellow}
}
getADUser $user $outFilePath
ii $outFilePath