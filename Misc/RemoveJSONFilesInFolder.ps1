<#
#Description: This script removes all files in a folder matching a set regex*
#Author: Robert Howell
#Date: 09/2024
#>
$Reg1 = '^[0-9]{8}$'
$files = (Get-ChildItem -recurse | where{$_.Name -like "*.json"})

foreach ($item in $files) {
    Remove-Item -Path $item.PSPath
}