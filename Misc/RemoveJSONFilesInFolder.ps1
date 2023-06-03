#Remove all files in folder matching regex*
$Reg1 = '^[0-9]{8}$'
$files = (Get-ChildItem -recurse | where{$_.Name -like "*.json"})

foreach ($item in $files) {
    Remove-Item -Path $item.PSPath
}