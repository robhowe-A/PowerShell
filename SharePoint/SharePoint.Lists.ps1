<#
#Description: This script outputs SharePoint Server web properties
#Author: Robert Howell
#Date: 09/2024
#Notes: 
    -get list properties of sharepoint websites:
#>
$sites = get-spsite
$sites.AllWebs

$web = get-spweb http://sharepoint.hyperspace.local:34881  
#$web.Lists | select * -ExcludeProperty *xml* -First 1
$web.Lists | select title, id, hidden

#list all lists in a sharepoint website
#visibile and hidden lists namd,ids will be displayed
$url = "http://sharepoint.hyperspace.local:34881"

function getWebLists($url){
    $web = get-spweb $url
    $web.Lists | select title, id, hidden
}
getWebLists $url