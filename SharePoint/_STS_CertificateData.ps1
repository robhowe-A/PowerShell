<#
#Description: This script writes SharePoint Server Security Token Service (STS) output properties to the output file path
#Author: Robert Howell
#Date: 09/2024
#>
#function variables
$searchPath = "Cert:\LocalMachine"
$certDataOutFilePath = "$([System.Environment]::GetEnvironmentVariable("USERPROFILE").toString())\documents\STScertdata.txt"

#known attributes
$thumbprint = ""

#Function to export STS certificate data
function getSTSCertificate($thumbprint, $certDataOutFilePath) {
    if($thumbprint){
        #match the input thumbprint search
        $certData = Get-ChildItem `
        -Recurse `
        -Path $searchPath `
        | ? {$_.thumbprint -match $thumbprint} `
        | select * `
    }
    else {
        #search for STS token
        $certData = Get-ChildItem `
        -Recurse `
        -Path $searchPath `
        | ? {$_.subject -like "*CN=SharePoint Security Token Service Encryption*"} `
        | select * `
    }

    if ($certData){
        #export the data to an output file
        $certData | Out-File `
            -FilePath $certDataOutFilePath
    }
    else {
        Write-Host "No STS data found." -ForegroundColor Yellow
    }
}

getSTSCertificate $thumbprint $certDataOutFilePath
ii $certDataOutFilePath