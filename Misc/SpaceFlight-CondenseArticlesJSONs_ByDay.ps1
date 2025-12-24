<#
#Description: This script uses a regex filter for a custom project of mine. Complex string 
    manipulations combined json files by day into an aggregate file.
#Author: Robert Howell
#Date: 09/2024
#>
$path = "C:\GitHub\Repositories-Files\PowerShell\Misc\FileStore_Test"

#######################MARCH############################
#Match a string regex - ALL FILES THROUGH MONTH 9
$Reg2 = '^[0-9]{4}[0-9]{2}[0-3]{1}[0-9]$'
$files = (Get-ChildItem | where{$_.Name -match "$Reg2*"})


#PROCESS FILES BY DAY
#Group the files into days sorted by the name
$month=01
$i=1
for($i=1;$i -le 31;$i++){
    $str = "$i"
    if ($i -lt 10){
        $str = "0"+"$i"
    }
    Write-Host "Day is"$str
    $Newfile = $path + "\SUMDAY-2022$($month)$($str).json"
    $filesDay = $files | where{$_.Name -like "2022$($month)$($str)*.json"}

    #First file remove the last character
    $file1 = $filesDay | Select-Object -First 1
    $text = Get-Content $file1
    $textOBJ = $text.Substring(0,$text.Length-1) | Out-File -Append -NoNewline $Newfile
    
    #---> remove the last character in the string and insert a ","
    $filesDay | Select-Object -Skip 1 | ForEach-Object { 
    $text = Get-Content $_
    $textOBJ = $text.Remove(0,1).Insert(0,",")
    $textOBJ1 = $textOBJ.Substring(0,$textOBJ.Length-1) | Out-File -Append -NoNewline $Newfile
    }
    "]" | Out-File -Append -NoNewline $Newfile #append "]" to end the string
    
    #Check the new file for string errors
    $newText = Get-Content $Newfile
    
    # Replace invalid JSON characters
    #$newText.replace("â€œ", "'").Replace("â€™","'").replace('\n','\\n').replace('\"','').replace('“','\"') | Out-File -NoNewline $Newfile
        
    #Create a new file and add the condensed content
    $From = Get-Content -Path $Newfile
    $NewFile2 = New-Item -Path "$($path)\SUMDAY2-2022$($month)$($str).json" -ItemType File
    Add-Content -Path $NewFile2 -Value $From
}
