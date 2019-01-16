#
# BEFORE USING PLEASE READ THE FOLLOWING!
# 
# Many exe installers will extract/contain and MSI file inside them that can be deployed directly via GPO
# please open your exe files with 7-ZIP to check for compressed MSI files BEFORE using this script to deploy!
#
# When using this script to deploy via GPO you MUST use a silent switch (/s, /silent, /q, etc.) as an argument
# or your application will not deploy properly. You can find a large list of application silent install parameters
# at https://www.manageengine.com/products/desktop-central/software-installation/windows-software.html

Param(
    $AppPath,
    $AppName,
    $AppVersion,
    $Uninstall
)

# Function to check if application is already installed
FUNCTION GetApplication($name, $version) {
    $applications = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*
    if ($name -ne $null) {
        return $applications | Where-Object {$_.DisplayName -match $name} | Select-Object DisplayName, DisplayVersion, UninstallString
    }
    elseif ($name -ne $null -And $version -ne $null) {
        return $applications | Where-Object {$_.DisplayName -match $name -And $_.DisplayVersion -match $version} | Select-Object DisplayName, DisplayVersion, UninstallString
    }
}


if ($AppName -ne $null -And $AppPath -ne $null -And $AppVersion -eq $null) {
    # If only the name is specified and the application exist do not continue
    if (GetApplication($AppName)) {
        Write-Output "Application already installed, skipping"
        exit 0
    }
    # This should execute the installer
    cmd.exe /C "$AppPath"
    Write-Output "Application Installed"
    exit 0
}
elseif ($AppName -ne $null -And $AppPath -ne $null -And $AppVersion -ne $null) {
    if (GetApplition($AppName, $AppVersion)) {
        Write-Output "Application already installed, skipping"
        exit 0
    }
    # This should install the application
    cmd.exe /C "$AppPath"
    Write-Output "Application Installed"
    exit 0
}
elseif ($AppName -eq $null -Or $AppPath -eq $null) {
    Write-Error "You must specify an AppName and an AppPath"
    exit 2
}