<#
#Description: This script writes configuration details of the applications running in a selected app pool to an output file
#Author: Robert Howell
#Date: 09/2024
#Parameters: 
    -$AppPoolNames - Taking in a commma separated array of app pool names
    -$FilePath - The output file path

    #EX: 
        PS PowerShell> $AppPoolNames = @('DefaultAppPool', 'Developer-5001')
        PS PowerShell> .\outFileAppPoolApplicationConfig.ps1 -AppPoolNames $AppPoolNames -FilePath "C:\Users\spfarm\Documents\SharePoint_Data\ApplicationsConfig.txt"
#>
param(
    [Parameter(
        Mandatory=$false,
        HelpMessage="App pool name(s) separated by a ','. 
        Default: 
            #DefaultAppPool, 
            #SecurityTokenServiceApplicationPool, 
            #SharePoint Web Services System"
        )]
    [string[]]$AppPoolNames = @('DefaultAppPool', 'SecurityTokenServiceApplicationPool', 'SharePoint Web Services System'),
    [Parameter(
        Mandatory=$false,
        HelpMessage="Object output file location."
        )]
    [string]$FilePath = "$($env:USERPROFILE)\documents\appPoolApplicationData.txt"
)

Start-Transcript $FilePath #used for output file record

function getApplicatoinConfigData($AppPoolNames){

    #loop through application pool name(s) of ingress parameter data
    foreach($appPool in $AppPoolNames){
        #Friendly data output separates each config data set, per application pool
        Write-Host "#####################################"
        Write-Host "Application Pool: " -ForegroundColor DarkCyan -NoNewline
        Write-Host "$($appPool)" -ForegroundColor Cyan
        Write-Host "#####################################`n"

        #Get IIS config data for the application
        #The output set is a 'Microsoft.Web.Administration.ConfigurationElement' object type
        Get-IISSite | `
            Where-Object{$_.applications.ApplicationPoolName -match $appPool} | `
            select -ExpandProperty applications
    }
}
getApplicatoinConfigData $AppPoolNames
Stop-Transcript
ii $FilePath