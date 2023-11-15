This development has a story:

## Background:

I wanted a PowerShell script that gives me file details from a file's property tab. I have a folder that has hundreds of files and I want to confirm the version number of all the files - the files in the file folder have various extension types like dlls, executables, and object files. The project is related to my SpaceFlightWeb repository at [robhowe-A/SpaceFlightWeb: SpaceFlight Web Console by Blazor Web Assembly and API](https://github.com/robhowe-A/SpaceFlightWeb).

I figured file details were easy to access, so I search-engine-researched a solution with the hopes of getting a stackoverflow response or powershell reference document with the starting code. Instead of getting stackoverflow in the results, I got Copilot. If you're not familiar with Copilot, it's an AI chat bot that you see in Bing. It's very very helpful and intuitive.

The Copilot response was a PowerShell offering (just like I searched for). It looked unfamiliar and incorrect, so I looked at the search engine's results. Reviewing some of the code, it looks like it's extremely difficult to do this in PowerShell; many of the sample scripts were ~50 lines of code or more. Reviewing Copilot's code, it's only 4 lines of code, so I thought I'd give it a go. Here's the code it gave me:

```PowerShell
$app = New-Object -COM 'Shell.Application'
$f = Get-Item 'C:\pathtoyourfile'
$dir = $app.NameSpace ($f.Directory.FullName)
$description = $dir.GetDetailsOf ($dir.ParseName ($f.Name), 2)
```

## Troublshooting

When Copilot's code is run, it fails with syntax errors. Clearing those, the code runs fine, but does not give any result. Adding <code>$description</code> gave me the result in the details section I was looking for.

### Results

- Copilot PowerShell script edited (fixed) to display results
  > ```PowerShell
  > $app = New-Object -COM 'Shell.Application'
  > $f = Get-Item "C:\inetpub\wwwroot\Spaceflight news deploy\clrgc.dll"
  > $dir = $app.NameSpace($f.Directory.FullName)
  > $description = $dir.GetDetailsOf($dir.ParseName($f.Name), 2)
  > $description
  > ```

| Result (PowerShell): "Application extension" | Result (Details tab): Type: Application extension        |
| -------------------------------------------- | -------------------------------------------------------- |
| <img src="2023-11-15 11_24_33.png">          | <img src="2023-11-15 10_15_44-clrgc.dll Properties.png"> |

It turns out this code does not reveal the product version. Instead, there are only some of the details tab information properties it <i>can</i> reveal, described here: [Folder.GetDetailsOf method (Shlobj_core.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/shell/folder-getdetailsof). However, I was able to get to the product version after some exploration from the provided <code>Get-Item -Path "path" | Select-Object -ExpandProperty versioninfo | FL</code>.

<img src="2023-11-15 10_24_23.png">

The output is singular, so I put together a list view. Here's the code:

- Final PowerShell Script

```PowerShell
$files = Get-ChildItem -Path "C:\inetpub\wwwroot\Spaceflight news deploy\"
$resultlist = New-Object -TypeName System.Collections.ArrayList
foreach ($file in $files) {
    if ([bool](Get-Member -Name VersionInfo -InputObject $file -MemberType ScriptProperty)) {
        $item = Get-Item -Path $file.VersionInfo.FileName | Select-Object -ExpandProperty versioninfo
        [void]$resultlist.Add($item)
    }
}
$resultlist | Format-Table `
    @{
        n="FileName";
        e={
            $filename = $_.FileName.Split("\")
            $filename[$filename.Length -1]
        }
    }, `
    ProductVersion
```

<img src="2023-11-15 11_35_22.png">
