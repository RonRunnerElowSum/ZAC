$LatestZACVersion = "8.0.24"

$32bitDownloadURL = "https://mirror.zultys.biz/ZAC/ZAC_x86-$LatestZACVersion.exe"
$64bitDownloadURL = "https://mirror.zultys.biz/ZAC/ZAC_x64-$LatestZACVersion.exe"

function InstallUpdateZAC32 () {
    if(!(Test-Path -Path C:\Temp)){New-Item -Path "C:\" -Name "Temp" -ItemType "directory" | Out-Null}
    if(!(Test-Path -Path "C:\Temp\ZAC")){New-Item -Path "C:\Temp" -Name "ZAC" -ItemType "directory" | Out-Null}
    Invoke-WebRequest -URI $32bitDownloadURL -OutFile "C:\Temp\ZAC\ZAC_x86-$LatestZACVersion.exe"
    if(Get-Process "ZAC" -ErrorAction SilentlyContinue){Stop-Process -Name "ZAC" -Force}
    if(Get-Process "ZultysCrashHandler" -ErrorAction SilentlyContinue){Stop-Process -Name "ZultysCrashHandler" -Force}
    Start-Process "C:\Temp\ZAC\ZAC_x86-$LatestZACVersion.exe" -ArgumentList "/S /v/qn" -Wait
    if((Get-ItemProperty -Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*) | Where-Object {$_.DisplayName -eq "ZAC"} | Where-Object {$_.DisplayVersion -eq "$LatestZACVersion"}){
        $ZACVersion = ((Get-ItemProperty -Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*) | Where-Object {$_.DisplayName -eq "ZAC"}).DisplayVersion
        Write-Host "ZAC (v$ZACVersion) installed successfully!"
        EXIT
    }
    else{
        Write-Warning "ZAC (v$ZACVersion) failed to install...exiting..."
        EXIT
    }
}

function InstallUpdateZAC64 () {
    if(!(Test-Path -Path C:\Temp)){New-Item -Path "C:\" -Name "Temp" -ItemType "directory" | Out-Null}
    if(!(Test-Path -Path "C:\Temp\ZAC")){New-Item -Path "C:\Temp" -Name "ZAC" -ItemType "directory" | Out-Null}
    Invoke-WebRequest -URI $64bitDownloadURL -OutFile "C:\Temp\ZAC\ZAC_x64-$LatestZACVersion.exe"
    if(Get-Process "ZAC" -ErrorAction SilentlyContinue){Stop-Process -Name "ZAC" -Force}
    if(Get-Process "ZultysCrashHandler" -ErrorAction SilentlyContinue){Stop-Process -Name "ZultysCrashHandler" -Force}
    Start-Process "C:\Temp\ZAC\ZAC_x64-$LatestZACVersion.exe" -ArgumentList "/S /v/qn" -Wait
    if((Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*) | Where-Object {$_.DisplayName -eq "ZAC"} | Where-Object {$_.DisplayVersion -eq "$LatestZACVersion"}){
        $ZACVersion = ((Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*) | Where-Object {$_.DisplayName -eq "ZAC"}).DisplayVersion
        Write-Host "ZAC (v$ZACVersion) installed successfully!"
        EXIT
    }
    else{
        Write-Warning "ZAC (v$ZACVersion) failed to install...exiting..."
        EXIT
    }
}

function PunchIt () {
    $OSArch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
    if($OSArch -eq "32-bit"){
        Write-Host "Checking if ZAC is installed..."
        if((Get-ItemProperty -Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*) | Where-Object {$_.DisplayName -eq "ZAC"}){
        $ZACVersion = ((Get-ItemProperty -Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*) | Where-Object {$_.DisplayName -contains "ZAC"}).DisplayVersion
        Write-Host "ZAC (v$ZACVersion) is installed...checking if ZAC is up-to-date..."
            if($ZACVersion -eq $LatestZACVersion){
                Write-Host "ZAC is up-to-date!"
                EXIT
            }
            else{
                Write-Host "ZAC is not up-to-date...updating now..."
                InstallUpdateZAC32
            }
        }
        else{
            Write-Host "ZAC is not installed...installing now..."
            InstallUpdateZAC32
        }
    }
    elseif($OSArch -eq "64-bit"){
        Write-Host "Checking if ZAC is installed..."
        IWR -URI 'https://mywebsite.com/myscipt.ps1' -UseBasicParsing | IEX; PunchIt
        if((Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*) | Where-Object {$_.DisplayName -eq "ZAC"}){
        $ZACVersion = ((Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*) | Where-Object {$_.DisplayName -contains "ZAC"}).DisplayVersion
        Write-Host "ZAC (v$ZACVersion) is installed...checking if ZAC is up-to-date..."
            if($ZACVersion -eq $LatestZACVersion){
                Write-Host "ZAC is up-to-date!"
                EXIT
            }
            else{
                Write-Host "ZAC is not up-to-date...updating now..."
                InstallUpdateZAC64
            }
        }
        else{
            Write-Host "ZAC is not installed...installing now..."
            InstallUpdateZAC64
        }
    }
}
