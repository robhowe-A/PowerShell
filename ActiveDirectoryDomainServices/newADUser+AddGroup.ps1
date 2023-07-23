<#
Title: newADUser+AddGroup.ps1
Author: Robert Howell
Description: This script is example code demonstrating the creation of active directory
    users in bulk. It can be used when multiple accounts are needed created having similar attributes.
    A For loop cycles the variable's values, creating unique user IDs sharing the same attributes. Single accounts
    needing different attribute values are unaccounted for and need to be entered manually.
        
Details: 
-This script adds the "DeveloperPortal" group permission to the account membership.

    Instructions:
    1. Confirm variables.
        -The number of users and user attributes can be modified
    2. Begin the script. You will be prompted to enter a password, which will be the account's password from start.
    3. Monitor the output for progress and/or errors.
    
    Notes:
    - Account numbers are added to the account name upon creation.
        EX: First Name = sp, Last Name = user
            RESULT: spuser1
                    spuser2
                    ...
                    spuser<n>
    - All passwords start as the same, so the accounts are disabled. It is expected each user to create
        a new password when the account is activated.
    - AD information is populated such as: city, dept, division, and title

#>
$newusrcount = 100;
$city = "Naboo"
$dept = "Separatists"
$division = "Droid Army Communications"
$title = "Communications Devs"
$firstname = "sp"    #First Name. Used in combination with $lastname for the username
$lastname = "designer"
$givenname = "SharePoint"    #used in Display Name
$surname = "Designer"    #used in Display Name

#do not use plain text password in production environment, the text may show up
#in logs or events. This default (uncommented) value is prompted upon script run:
$userPassword = Read-Host -AsSecureString

<# Uncomment to use hard coded password
Write-Warning "You are about to use a password as plain text." -WarningAction Inquire
$userPassword = ConvertTo-SecureString "TwelvecharP@ssw0rd" -AsPlainText -Force
#>

for ($i=2; $i -le $newusrcount+1; $i++){
    $fname = "$firstname"
    $lname = "$lastname$($i)"
    $name = "$($fname)$($lname)"
    $gn = $givenname
    $sn = "$surname$($i)"
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
            -AccountPassword $userPassword `
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
