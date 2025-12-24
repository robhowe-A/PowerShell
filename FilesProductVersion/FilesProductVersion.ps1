<#
#Description: This script outputs file information properties  
#Author: Robert Howell
#Date: 09/2024
#>
$files = Get-ChildItem -Path "C:\inetpub\wwwroot\Spaceflight news deploy\"
$resultlist = New-Object -TypeName System.Collections.ArrayList
foreach ($file in $files) {
    if ([bool](Get-Member -Name VersionInfo -InputObject $file -MemberType ScriptProperty)) {
        $item = Get-Item -Path $file.VersionInfo.FileName | Select-Object -ExpandProperty versioninfo
        [void]$resultlist.Add($item)
    }
}
$resultlist | Format-Table FileName, ProductVersion