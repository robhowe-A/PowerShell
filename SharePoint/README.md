# What is it?

- An example library of common PowerShell scripts used in everyday administrative tasks

# Who is it for?

- These scripts are used by SharePoint farm administrators

# Where can it be used?

- Any SharePoint server gathers this information using the snap-in 'Microsoft.SharePoint.PowerShell'

## Example

```PowerShell
Add-PSSnapin *Microsoft.SharePoint.PowerShell* -ErrorAction SilentlyContinue
$outFilePath = "$($env:USERPROFILE)\documents\SPDatabases.txt"

Start-Transcript -Path $outFilePath
function getSPDatabase($outFilePath ) {
    
    $DBS = Get-SPDatabase | select * -ExcludeProperty *password*
    
    if ($DBS.length -gt 0){
        $CDBS = $DBS | ?{$_.type -match "Content Database"}
        $RDBS =  $DBS | ?{$_.type -ne "Content Database"}
        $DBArray = $CDBS, $RDBS

        #Output content databases first
        Write-Host "------------------------------------`
        Content Databases: " -ForegroundColor Cyan

        #Organize output
        $DBArray[0] | Sort-Object currentsitecount -Descending | `
            Select-Object name, CurrentSiteCount | ft -Autosize -Wrap

        #Output remaining databases
        Write-Host "------------------------------------`
        Remaining Databases: " -ForegroundColor Cyan
        #Organize output
        $DBArray[1] | Select-Object name, Type | ft -Autosize -Wrap

    }
}

getSPDatabase $outFilePath 
Stop-Transcript
ii $outFilePath
```
