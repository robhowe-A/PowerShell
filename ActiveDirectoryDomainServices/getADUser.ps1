<#
    Title: getaduser_accountdetails-TXT.ps1
    Author: Robert Howell
    Description: This script outputs a user account's property and attribute values to a
        text file.

    Details:
        This script can run from PowerShell command line.
            Parameters:
                -user
                -outFilePath

    Notes:
        -An output file path is not required. The text document will create in your documents folder as the default
        -The file name changes based on the user entered as the input, using the user's name as part of the file name
        -Only one user is run at a time
        -The PowerShell output provides basic details of the user
        -The PowerShell output provides the file path of the written file

#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    [string]$User,

    [Parameter(Mandatory=$false)]
    [string]$outFilePath
)

function getADUser($User, $outFilePath){
    begin{
        if ([string]::IsNullOrWhiteSpace($User)){
            $User = Read-Host "Enter a user (SamAccountName, DistinguishedName, GUID, or SID | enter any character for current user)"  #user by SamAccountName, DistinguishedName, GUID, or SID
            if ([string]::IsNullOrWhiteSpace($User)){
                Write-Host "No user information entered. Processing script with current user details." -F Yellow
                $User = $env:username
            }
        }
        if ([string]::IsNullOrWhiteSpace($outFilePath)){
            $outFilePath = "$($env:USERPROFILE)\documents\<user>-account-details.txt"
        }
    }
    process{
        try{
            $User = get-aduser -id $User -Properties * |`
                select *
        }
        catch {Write-Host "No user found. Error: $($_)" -ForegroundColor Yellow}
            #rename the file name in path str
            $str = $outFilePath.Split("\", $outFilePath.Length)
            $endstr = $str[$str.Length - 1]
            if ($endstr.EndsWith(".txt") -eq $False){
                #string is invalid input
                if($endstr.Contains(".")){
                    $tempstr = $str[$str.Length - 1].Split(".")
                    $tempstr[1] = "txt"
                    $str[$str.Length - 1] = [string]::Join(".",$tempstr)
                }
                else {
                    #string is a valid path, needs adding ".txt"
                    $str += "test.txt"
                }
            }
            $filename = $str[$str.Length - 1].Split(".")
            $filename[0] = $User.SamAccountName + "-account-details"
            $str[$str.Length - 1] = [string]::Join(".", $filename)
            $outFilePath = [string]::Join("\", $str)


            #output user details. A summary is written to the console. Details are written to the user fil
            Write-Host "User details found: " -F Cyan
            "# Below are all the user property and attribute values from Active Directory" | Out-File -FilePath $outFilePath
            "# get-aduser -id `$User -Properties * select *" | Out-File -FilePath $outFilePath -Append
            "`n##########################################" | Out-File -FilePath $outFilePath -Append
            "Name: $($User.Name)" | Tee-Object -FilePath $outFilePath -Append
            "Username: $($User.SamAccountName)" | Tee-Object -FilePath $outFilePath -Append
            "Enabled: $($User.Enabled)" | Tee-Object -FilePath $outFilePath -Append
            "Location: $($User.DistinguishedName)" | Tee-Object -FilePath $outFilePath -Append
            "SID: $($User.SID)" | Tee-Object -FilePath $outFilePath -Append
            "##########################################" | Out-File -FilePath $outFilePath -Append
            $User | Out-File -FilePath $outFilePath -Append
            "`n`n##########################################" | Out-File -FilePath $outFilePath -Append -NoNewline
            Write-Host "`n`tUser details written to `"$outFilePath`"" -F Green
        }
    end{
        if(@(Get-Content $outFilePath) -ne $null){
            ii $outFilePath
        }
    }
}

getADUser $User $outFilePath
