asnp *SharePoint* -ErrorAction SilentlyContinue

##########################################
#Create a new web applicatoin
##Variables

$Name = 'DeveloperPublishing'
$Port = 5001
$HostHeader = 'developer.hyperspace.local'
$ApplicationPool = 'Developer-5001'
$ApplicationPoolAccount = (Get-SPManagedAccount "HYPERSPACE\spfarm")
$DatabaseName = 'WSS_Web-DeveloperPublishing'

New-SPWebApplication `
    -Name $Name `
    -Port $Port `
    -HostHeader $HostHeader `
    -ApplicationPool $ApplicationPool `
    -ApplicationPoolAccount $ApplicationPoolAccount `
    -DatabaseName $DatabaseName `
    -DatabaseServer 'WIN-4T86T2A0TU5' `
    -AuthenticationMethod 'NTLM' `