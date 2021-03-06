#===================================================================================================
#   Test-WinPE
#===================================================================================================
if ($env:SystemDrive -ne "X:") {
    Write-Warning "CloudPE can only be run from WinPE"
    Break
}


Invoke-Expression https://raw.githubusercontent.com/OSDeploy/OSD/21.3.5.2/Public/Disk/Get-LocalPartition.ps1


Break

$GetPSScriptRoot = Get-Item $PSScriptRoot
$GetPSDrive = ($GetPSScriptRoot).PSDrive
$GetConnect = ($GetPSScriptRoot).FullName
$DeployRoot = (Get-Item $PSScriptRoot).parent.FullName
$DeployPath = ($DeployRoot -split ":")[1]
#===================================================================================================
#   Get Partition
#===================================================================================================
$GetPartition = Get-Partition | Where-Object {$_.DriveLetter -match $GetPSDrive}
if ($GetPartition) {
    $DiskNumber = $GetPartition | Where-Object {$_.DriveLetter -match $GetPSDrive} | Select-Object -ExpandProperty DiskNumber
    $GetUSBDisk = Get-Disk -Number $DiskNumber
    $GetUSBPartition = $GetPartition
} else {
    $GetUSBDisk = $false
    $GetUSBPartition = $false
}
#===================================================================================================
#   Start Menu
#===================================================================================================
Clear-Host
Write-Host -ForegroundColor DarkCyan "================================================================="
if ($GetUSBDisk) {
    Write-Host "BHIMAGE Connect on $DeployRoot [$($GetUSBDisk.FriendlyName)]" -ForegroundColor Cyan
} else {
    Write-Host "BHIMAGE Connect on $DeployRoot" -ForegroundColor Cyan
}
Write-Host "FOR TESTING ONLY, NON-PRODUCTION"
#Write-Host -ForegroundColor DarkGray "PSDrive = $GetPSDrive"
#Write-Host -ForegroundColor DarkGray "Connect = $GetConnect"
Write-Host -ForegroundColor DarkCyan "================================================================="

Write-Host " A  " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "Windows AutoPilot"

Write-Host " AD " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "Windows AutoPilot Developer"

Write-Host " 64 " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "Windows 10 1909 x64"

Write-Host " X  " -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host "Exit"

Write-Host ""

do {
    $BuildImage = Read-Host -Prompt "Enter an option, or X to Exit"
}
until (
    (
        ($BuildImage -eq 'A') -or #AutoPilot
        ($BuildImage -eq 'AD') -or #AutoPilot DEV Testing
        ($BuildImage -eq '64') -or #Standard Image Testing
        ($BuildImage -eq 'X')
    ) 
)