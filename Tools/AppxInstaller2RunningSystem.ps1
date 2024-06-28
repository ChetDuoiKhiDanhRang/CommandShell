#https://github.com/ChetDuoiKhiDanhRang/PowerShell
$folder = Split-Path -Parent $PSCommandPath 
$cTime = Get-Date
$cTime = $cTime.ToString("yyyy.MM.dd HH:mm:ss")
"Folder: $folder" > "$folder\log.txt"
"Time  : $cTime" >> "$folder\log.txt"
"Author: ChetDuoiKhiDanhRang@voz.vn" >> "$folder\log.txt"

#get dependencies items
$dependencies = Get-ChildItem $folder\dependencies
$dependencies = $dependencies | Where-Object {$_.Name -match "[.Appx,.Msix,.Msixbundle,.AppxBundle]$" }

#get appxs items
$appxs = Get-ChildItem $folder\appx | Where-Object {$_.Name -match "[.Appx,.Msix,.Msixbundle,.AppxBundle]$" }

"Install dependencies:" >> "$folder\log.txt"
#install dependencies:
foreach ($d in $dependencies){
     "Install dependency: $($d.Name)">> "$folder\log.txt"
     Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath $d.fullname
     if ($?) {
     "  >>Success!" >> "$folder\log.txt"
     } else {
     "  >>Fail!" >> "$folder\log.txt"
     }
}


"Install Appx:" >> "$folder\log.txt"
foreach ($a in $appxs){
     "Install appx: $($a.Name)">> "$folder\log.txt"
     Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath $a.fullname
     if ($?) {
     "  >>Success!" >> "$folder\log.txt"
     } else {
     "  >>Fail!" >> "$folder\log.txt"
     }
}