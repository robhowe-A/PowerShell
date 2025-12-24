<#
#Description: This script outputs SharePoint Server services upgrade properties
#Author: Robert Howell
#Date: 09/2024
#>
Add-PSSnapin *Microsoft.SharePoint.PowerShell* -ErrorAction SilentlyContinue

Get-SPService | select TypeName, Required, Hidden, NeedsUpgrade |`
    Sort-Object -Property `
        @{Expression="Required";Descending="$false"},`
        @{Expression="TypeName";Descending="$false"}