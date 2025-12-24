<#
#Description: This script creates a new web application in a SharePoint farm.
#Advantages: 
    -Coded parameters control a web application's creating parameters for an environment.
    -The script can be saved and reused at later times.
    -A transcript can be recorded of the creating instance. #TODO?
#Author: Robert Howell
#Parameters: 
    New-SPWebApplication #sharepoint site collection's parent
    -Name     #Web app name
    -Port     #Port 80/443 or non-standard port
    -HostHeader     #URL domain identifier. The same value as IIS binding.
    -ApplicationPool     #Name of the app pool this web app operates within
    -ApplicationPoolAccount     #Web application service account
    -DatabaseName     #Content database name
    -DatabaseServer     #Database server name
    -AuthenticationMethod     #Auth method by user login

EXAMPLE:    
PS C:\...\Desktop\PowerShell> .\SharePoint.NewWebApplication.ps1

    cmdlet SharePoint.NewWebApplication.ps1 at command pipeline position 1
    Supply values for the following parameters:
    (Type !? for Help.)
    Name: DeveloperPublishing
    Port: 5001
    HostHeader: developer.hyperspace.local
    ApplicationPool: Developer-5001
    PoolAccount: HYPERSPACE\spfarm
    DatabaseName: WSS_Web-Developer
#>
#Parameter validation
param(
    [Parameter(
        Mandatory=$true,
        HelpMessage="The web application's name."
        )]
    [string]$Name = "DeveloperPublishing",

    [Parameter(
        Mandatory=$true,
        HelpMessage="The operating port."
        )]
    [Int32]$Port = 5001,

    [Parameter(
        Mandatory=$true, #can be false, however, this ensures SharePoint = IIS binding
        HelpMessage="IIS binding host name."
        )]
    [string]$HostHeader = 'developer.hyperspace.local',

    [Parameter(
        Mandatory=$true,
        HelpMessage="The application pool name to emplace web application. Must either be empty or non-existing."
        )]
    [string]$ApplicationPool = 'Developer-5001',

    [Parameter(
        Mandatory=$true,
        HelpMessage="The application pool account. Format: Domain\user",
        ParameterSetName="ApplicationPoolAccount"
        )]
    [string]$PoolAccount = 'HYPERSPACE\spfarm',

    [Parameter(
        Mandatory=$true,
        HelpMessage="Web application database name."
        )]
    [string]$DatabaseName = 'WSS_Web-DeveloperPublishing'

)
asnp *SharePoint* -ErrorAction SilentlyContinue

#Assignments
$ApplicationPoolAccount = (Get-SPManagedAccount $PoolAccount)
$DBServer = 'WIN-4T86T2A0TU5'
$AuthMethod = 'NTLM'

function NewWebApplication($Name, $Port, $HostHeader, $ApplicationPool, `
    $ApplicationPoolAccount, $DatabaseName, $DBServer, $AuthMethod){

    try{
        #Create Web Application
        New-SPWebApplication `
            -Name $Name `
            -Port $Port `
            -HostHeader $HostHeader `
            -ApplicationPool $ApplicationPool `
            -ApplicationPoolAccount $ApplicationPoolAccount `
            -DatabaseName $DatabaseName `
            -DatabaseServer $DBServer `
            -AuthenticationMethod $AuthMethod
    }
    catch { Write-Host "Cannot create web application. Error: $($_)" -ForegroundColor Yellow }
}
NewWebApplication $Name $Port $HostHeader $ApplicationPool `
    $ApplicationPoolAccount $DatabaseName $DBServer $AuthMethod