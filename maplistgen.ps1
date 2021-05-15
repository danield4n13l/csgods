Get-ChildItem -Recurse ./csgo/maps/workshop/ -Filter "*$($args[0])_*.bsp" | ForEach-Object { $_.FullName -ireplace "\\","/" -ireplace "(?:.+?(?=workshop))|(?:.bsp)",""}  > $PSScriptRoot/tmp.txt
Get-ChildItem -Recurse ./csgo/maps/custom/ -Filter "*$($args[0])_*.bsp" | ForEach-Object { $_.FullName -ireplace "\\","/" -ireplace "(?:.+?(?=custom))|(?:.bsp)",""}  >> $PSScriptRoot/tmp.txt
[System.IO.File]::WriteAllLines("$PSScriptRoot/mapcycle$(If ($null -ne $args[0]) {"_"+$args[0]} Else {}).txt", $(Get-Content -Path ./tmp.txt), $(New-Object System.Text.UTF8Encoding $False))
