<#
#Description: This script outputs SharePoint Server list properties
#Author: Robert Howell
#Date: 09/2024
#Notes: 
    -list all lists in a sharepoint website
    -visibile and hidden lists name,ids will be displayed
#>
$url = "http://sharepoint.hyperspace.local:34881"

function getWebLists($url){
    $web = get-spweb $url
    $web.Lists | select title, id, hidden
}
getWebLists $url