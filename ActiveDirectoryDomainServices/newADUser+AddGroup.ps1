<#
#Title: newADUser+AddGroup.ps1
Author: Robert Howell
Description: This script creates a new  active directory user and 
    adds "DeveloperPortal" security group membership
Ex: 'CN=SharePoint User1,CN=Users,DC=hyperspace,DC=local'

Parameters: 
-AD information is populated such as: city, dept, division, and title
-Multiple accounts may need added at once, with matching AD information
-The created accounts need to be manually enabled before they're allowed to log on
-All created accounts that are 'Communications Devs' are added to the "DeveloperPortal" group

#>
$newusrcount = 100;
$city = "Naboo"
$dept = "Separatists"
$division = "Droid Army Communications"
$title = "Communications Devs"

#do not use plain text password in production environment, the text may show up
#in logs or events. use instead:
#    $nuPassword = Read-Host -AsSecureString

<#
Write-Warning "You are about to use a password as plain text." -WarningAction Inquire
$nuPassword = ConvertTo-SecureString "TwelvecharP@ssw0rd" -AsPlainText -Force
#>

for ($i=2; $i -le $newusrcount+1; $i++){
    $fname = "sp"
    $lname = "user$($i)"
    $name = "$($fname)$($lname)"
    $gn = "SharePoint"
    $sn = "User$($i)"
    $upn = "$($name)@hyperspace.local"
    $displayName = "$($gn) $($sn)"

    #add the new user to active directory
    try{
        Write-Host "Creating AD user..." -ForegroundColor Green
        $user = New-ADUser `
            -Name $displayName `
            -SamAccountName $name `
            -DisplayName $displayName `
            -GivenName $gn `
            -Surname $sn `
            -UserPrincipalName $upn `
            -AccountPassword $nuPassword `
            -ChangePasswordAtLogon $false `
            -City $city `
            -Department $dept `
            -Division $division `
            -Title $title `
            -Enabled $false `
            -ErrorAction Stop #-WhatIf

    } catch {
        Write-Host "Cannot create the new AD user $($user.name). Error: " -ForegroundColor Yellow -NoNewline
        Write-Host $_ -ForegroundColor Red; return
    }
    #add the new user to group membership
    try{
        $user = Get-ADUser "$($name)"
        Write-Host "`tName: " -ForegroundColor DarkCyan -NoNewline
        Write-Host "$($user.name)" -ForegroundColor Cyan
        Write-Host "`tGUID: " -ForegroundColor DarkCyan -NoNewline
        Write-Host "$($user.ObjectGUID)" -ForegroundColor Cyan

        if($user){
            $DeveloperPortalGROUP = Get-ADGroup -Identity "CN=DeveloperPortal,OU=SharePoint,DC=hyperspace,DC=local"        
            Write-Host "Adding Membership: " -ForegroundColor DarkGreen
            Write-Host "`tGroup: " -ForegroundColor DarkCyan -NoNewline
            Write-Host "$($DeveloperPortalGROUP.Name)" -ForegroundColor Cyan
            Write-Host "`tSID: " -ForegroundColor DarkCyan -NoNewLine
            Write-Host "$($DeveloperPortalGROUP.SID)" -ForegroundColor Cyan -NoNewline
        
            Add-ADGroupMember `
                -Identity $DeveloperPortalGROUP `
                -Members $user #-WhatIf
        }
    } catch {
        Write-Host "Cannot add user membership. Error: " -ForegroundColor Yellow -NoNewline
        Write-Host $_ -ForegroundColor Red; return
    }
    #new user added successfully
    Write-Host "`t...Complete" -ForegroundColor Green
}
