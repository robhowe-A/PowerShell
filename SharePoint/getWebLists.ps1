#list all lists in a sharepoint website
#visibile and hidden lists namd,ids will be displayed
$url = "http://sharepoint.hyperspace.local:34881"

function getWebLists($url){
    $web = get-spweb $url
    $web.Lists | select title, id, hidden
}
getWebLists $url