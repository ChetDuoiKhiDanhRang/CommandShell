#Author: Github.com/ChetDuoiKhiDanhRang
#https://github.com/ChetDuoiKhiDanhRang/PowerShell
function GetBasicInfo {
    $cTime = Get-Date #Get curent Date-Time
    $cTime = $cTime.ToString("yyyy.MM.dd-HH:mm:ss") #Date-time format

    $os = Get-ComputerInfo
    $osName = $os.WindowsProductName
    $osVersion = $os.OsVersion
    $osArchitecture = $os.OsArchitecture
    $computerManufacturer = $os.CsManufacturer
    $computerModel = $os.CsModel
    $CPU = ($os.CsProcessors).Name #| Select-Object -Property Name)
    $computerName = $os.CsName
    $Memory = $($os.CsTotalPhysicalMemory/1024/1024/1024).ToString("0.00") + " GB"
    $currentUser = $os.CsUserName
    #$currentFolder = Get-Item $PSCommandPath
    #$currentFolder = $currentFolder.Directory

    $stringFormat = "{0, -23}: {1}"

    $result = ""
    $result += "$($stringFormat -f "Author", "Github.com/ChetDuoiKhiDanhRang")"
    $result += "`n$($stringFormat -f "Source code", "https://github.com/ChetDuoiKhiDanhRang/CommandShell")"
    $result += "`n$($stringFormat -f "Date-time", $cTime)"
    $result += "`n$($stringFormat -f "OS name", $osName)"
    $result += "`n$($stringFormat -f "OS version", $osVersion)"
    $result += "`n$($stringFormat -f "OS architecture", $osArchitecture)"
    $result += "`n$($stringFormat -f "Computer manufacturer", $computerManufacturer)"
    $result += "`n$($stringFormat -f "Computer model", $computerModel)"
    $result += "`n$($stringFormat -f "Computer name", $computerName)"
    $result += "`n$($stringFormat -f "CPU", $CPU)"
    $result += "`n$($stringFormat -f "Memory", $Memory)"
    $result += "`n$($stringFormat -f "Current user", $currentUser)"
    #echo ($stringFormat -f "Current folder", $currentFolder)

    return $result
}

#Select folder
function FolderPicker {
    Add-Type -AssemblyName System.Windows.Forms
    $currentFolder = $PSScriptRoot

    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.InitialDirectory = $currentFolder
    $openFileDialog.Filter = 'Folders Only|*.FolderOnly.Cxx'
    $openFileDialog.AddExtension = $false
    $openFileDialog.CheckFileExists = $false
    $openFileDialog.CheckPathExists = $true
    $openFileDialog.DereferenceLinks = $true
    $openFileDialog.ShowHelp = $false
    $openFileDialog.Multiselect = $false
    $openFileDialog.ValidateNames = $false
    $openFileDialog.FileName = 'Folder Selection'
    $openFileDialog.RestoreDirectory = $true

    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $folderPath = [System.IO.Path]::GetDirectoryName($openFileDialog.FileName)
        return $folderPath
    }
    else
    {
        return $null
    }
}

#File(s) picker
function FilesPicker {
    param (
    [bool] $MultiSelect=$false
    )
    Add-Type -AssemblyName System.Windows.Forms
    $currentFolder = $PSScriptRoot

    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.InitialDirectory = $currentFolder
    $openFileDialog.Filter = 'All file|*.*'
    $openFileDialog.AddExtension = $false
    $openFileDialog.CheckFileExists = $true
    $openFileDialog.CheckPathExists = $true
    $openFileDialog.DereferenceLinks = $false
    $openFileDialog.ShowHelp = $false
    $openFileDialog.Multiselect = $MultiSelect
    $openFileDialog.ValidateNames = $false
    $openFileDialog.RestoreDirectory = $true

    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $selectedFiles = $openFileDialog.FileNames
        return $selectedFiles
    }
    else
    {
        return $null
    }
}

function GetFileFolderProperties{
    param ([string] $path)
    if (Test-Path -Path $path) {
        $item = Get-Item -Path $path | Get-Member -MemberType Property
        return $item
    } else { return $null }
}

$info = GetBasicInfo
$info > "log.txt"
start "log.txt"