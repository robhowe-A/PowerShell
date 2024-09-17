<#
#Description: This script outputs group members key to SharePoint Server
#Author: Robert Howell
#Date: 09/2024
#>
$outFile = "$($env:USERPROFILE)\documents\localAccount+Groups.txt"
Start-Transcript -Path $outFile

#Key SharePoint local groups and group members
    #Administrators
$ADMINISTRATORS = Get-LocalGroup | ?{$_.SID -eq "S-1-5-32-544"}
    #WSS_ADMIN_WPG
$WSS_ADMIN_WPG = Get-LocalGroup | ?{$_.name -eq "WSS_ADMIN_WPG"}
    #WSS_RESTRICTED_WPG_V4
$WSS_RESTRICTED_WPG_V4 = Get-LocalGroup | ?{$_.name -eq "WSS_RESTRICTED_WPG_V4"}
    #WSS_WPG
$WSS_WPG = Get-LocalGroup | ?{$_.name -eq "WSS_WPG"}
    #IIS users
$IIS_IUSRS = Get-LocalGroup | ?{$_.name -eq "IIS_IUSRS"}
    #RDP users
$RemoteDesktopUsersGroup = Get-LocalGroup | ?{$_.name -eq "Remote Desktop Users"}

#array of key groups
$keyGroups = `
    $ADMINISTRATORS,`
    $WSS_ADMIN_WPG,`
    $WSS_RESTRICTED_WPG_V4,`
    $WSS_WPG,`
    $IIS_IUSRS, `
    $RemoteDesktopUsersGroup

#display each member of the key group and their Name, ObjectClass, PrincipalSource member properties
foreach ($keyGroup in $keyGroups){
    try{
        $keyGroupUsers = Get-LocalGroupMember -Group $keyGroup -ErrorAction Stop
    }
    catch{
    Write-Host `
    "Problem getting group members. Information may not be complete for '$($keyGroup.Name) group'. Error$($_)" `
        -ForegroundColor Yellow}
    
    if($keyGroupUsers){
        Write-Host "--------------------------------------`
        $($keyGroup.Name) Members`n--------------------------------------" `
        -ForegroundColor Cyan

        #Show SharePoint groups description for detail transparency
        if ($keyGroup.Description.Contains("SharePoint")){
            Write-Host "$($keyGroup.Description)`n" -ForegroundColor Gray
        }
    
        #Show and highlight users' member properties
        foreach ($user in $keyGroupUsers){
            Write-Host $user.name -ForegroundColor Cyan -NoNewline
            Write-Host " is a " -ForegroundColor Gray -NoNewline
            Write-Host $user.ObjectClass -ForegroundColor Green -NoNewline
            Write-Host " in ObjectClass: " -ForegroundColor Gray -NoNewline
            Write-Host $user.PrincipalSource -ForegroundColor Green
        }
        Write-Host "`n`n`n"
    }
}

#list all local groups
$localGroups = Get-LocalGroup | select Name, PrincipalSource, ObjectClass #, SID
$localGroups
Write-Host "--------------------------------------`n`n"
Stop-Transcript
start $outFile