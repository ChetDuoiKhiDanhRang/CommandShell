#https://github.com/ChetDuoiKhiDanhRang
#chuỗi tham số từ khóa để tìm danh sách package phù hợp
#có thể dùng "," hoặc ";" hoặc " " ngăn cách giữa các từ khóa
param (
[String]$AppxName
)

#Danh sách mặc định Appx và Extension
if ($AppxName -eq ""){
    $AppxName += "AV1VideoExtension"
    $AppxName += ";WinAppRuntime"
    $AppxName += ";HEIFImageExtension"
    $AppxName += ";RawImageExtension"
    $AppxName += ";HEVCVideoExtensions"
    $AppxName += ";HEVCVideoExtension"
    $AppxName += ";MPEG2VideoExtension"
    $AppxName += ";VP9VideoExtensions"
    $AppxName += ";WebMediaExtensions"
    $AppxName += ";WebpImageExtension"
    $AppxName += ";WindowsStore"
    $AppxName += ";DesktopAppInstaller"
    $AppxName += ";ScreenSketch"
    $AppxName += ";Windows.Photos"
    $AppxName += ";WindowsCamera"
}


$packageList = @()
#[PSCustomObject]@{Name="Microsoft.AV1VideoExtension"; Type= "Extension"},
#[PSCustomObject]@{Name="Microsoft.HEIFImageExtension"; Type= "Extension"},   
#[PSCustomObject]@{Name="Microsoft.RawImageExtension"; Type= "Extension"},    
#[PSCustomObject]@{Name="Microsoft.HEVCVideoExtensions"; Type= "Extension"},  
#[PSCustomObject]@{Name="Microsoft.HEVCVideoExtension"; Type= "Extension"},  
#[PSCustomObject]@{Name="Microsoft.MPEG2VideoExtension"; Type= "Extension"},  
#[PSCustomObject]@{Name="Microsoft.VP9VideoExtensions"; Type= "Extension"},   
#[PSCustomObject]@{Name="Microsoft.WebMediaExtensions"; Type= "Extension"},   
#[PSCustomObject]@{Name="Microsoft.WebpImageExtension"; Type= "Extension"},   
#[PSCustomObject]@{Name="Microsoft.WindowsStore"; Type= "Appx"},         
#[PSCustomObject]@{Name="Microsoft.DesktopAppInstaller"; Type= "Appx"},  
#[PSCustomObject]@{Name="Microsoft.ScreenSketch"; Type= "Appx"},         #được cài sẵn trong IoT LTSC 2024 - sẽ tự loại bỏ
#[PSCustomObject]@{Name="Microsoft.Windows.Photos"; Type= "Appx"},       
#[PSCustomObject]@{Name="Microsoft.WindowsCamera"; Type= "Appx"})        

#output file
$folder = Split-Path -Parent $PSCommandPath
$outputFileName = "AppxDependencies.txt"
$outputFile = "$outputFileName"

#Xin ít thông tin...
$cTime = Get-Date
$cTime = $cTime.ToString("yyyy.MM.dd HH:mm:ss")
$osi = Get-ComputerInfo

#phân giải chuỗi tham số đưa vào thành danh sách các tên
$AppxArray = $AppxName -split "[,; ]" | Where-Object {$_ -ne "" -or $_ -ne " "}
$AppxArray
#Loại bỏ ScreenSketch khỏi danh sách dò tìm trên các bản windows 11
if ($osi.OsBuildNumber -ge 22000) {
    "#OS build number: $($osi.OsBuildNumber)" >> $outputFile
    "#Remove ScreenSketch from list." >> $outputFile
    $AppxArray = $AppxArray.Where({$_ -notmatch "ScreenSketch"}) # | Where-Object {$_ -notmatch "ScreenSketch"}
}

#danh sách tổng hợp dependencies
$dependenciesCollection = @()

#Thông tin:
"Manufacturer     : $($osi.CsManufacturer)" > "$outputFile"
"Computer Model   : $($osi.CSModel)" >> "$outputFile"
"Computer Name    : $($osi.CsName)" >> "$outputFile"
"OS Edition       : $($osi.WindowsProductName)" >> "$outputFile"
"OS Version       : $($osi.OSVersion)" >> "$outputFile"
"Folder           : $folder" >> "$outputFile"
"Time             : $cTime" >> "$outputFile"
"Author           : Github/ChetDuoiKhiDanhRang" >> "$outputFile"
"Keyword to search:" >> "$outputFile"
foreach ($name in $AppxArray) {
    "`t-$($name)" >> "$outputFile"
}

#truy tìm các package theo từ khóa trong AppxArray và lập danh sách vào $packageList
foreach ($name in $AppxArray) {
    if ($name -eq "") {continue}
    
    #tìm danh sách package phù hợp theo tên
    $seachPackages = Get-AppxPackage -Name *$name* | Select-Object Name,PackageFamilyName,Version,Architecture

    foreach ($package in $seachPackages){
        #$packageObject = [PSCustomObject]@{
        #    Name = $package.Name
        #    Version = $package.Version
        #    Architecture = $package.Architecture
        #}
        $packageList += $package
    }
}

#Sắp xếp tí - lọc trùng nữa
$packageList = $packageList | Sort-Object -Unique -Property Name #-Descending
"=====================================================================================================" >> "$outputFile"
"#DETAIL FOR EACH PACKAGE:" >> "$outputFile"
#duyệt danh sách package
$count = 1
foreach ($package in $packageList){
    echo "[$($count).$($package.PackageFamilyName)]" >> "$outputFile"
    "`tVersion: $($package.Version)" >> "$outputFile"
    "`tDependencies:" >> "$outputFile"

    #lấy danh sách dependencies của package
    $dependencies = Get-AppxPackage $package.Name | Select-Object -ExpandProperty Dependencies | Select-Object Name,PackageFamilyName,Version,Architecture
    
    #loại bỏ bản thân tên package khỏi danh sách dependencies của gói
    $dependencies = $dependencies | Where-Object {$_.Name -notmatch $package.Name}

    #ghi ra file $outputFile
    $print = $dependencies | Select-Object PackageFamilyName,Version,Architecture
    echo $print >> "$outputFile"

    #duyệt danh sách dependencies vừa lấy
    foreach ($dependency in $dependencies){
        #ghi danh sách vào danh sách tổng hợp Dependencies
        $dependenciesCollection += $dependency
    }  

    $count = $count + 1
}
"=====================================================================================================" >> "$outputFile"
"#APPX AND EXTENSIONS:" >> "$outputFile"
#Đưa danh sách ra file
echo $packageList | Select-Object PackageFamilyName,Version,Architecture  >> "$outputFile"

"=====================================================================================================" >> "$outputFile"
"#DEPENDENCIES:"  >> "$outputFile"
#Lấy danh sách tổng hợp dependencies không trùng lặp
$dependenciesCollection = $dependenciesCollection | Select-Object -Unique -Property PackageFamilyName,Version,Architecture

#Sắp xếp danh sách
$dependenciesCollection = $dependenciesCollection | Sort-Object -Property Architecture,PackageFamilyName,Version

#Đưa danh sách ra file
echo $dependenciesCollection >> "$outputFile"
Start-Process $outputFile
#$DependenciesCollection