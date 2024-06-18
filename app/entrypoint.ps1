# Get current timestamp
function Get-Timestamp {
    return (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

Write-Output "$(Get-Timestamp): Starting script"

# Start WinAppDriver
Write-Output "$(Get-Timestamp): Starting WinAppDriver"
Start-Process -NoNewWindow -FilePath "C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe"

# Check for Developer Mode
Write-Output "$(Get-Timestamp): Checking Developer Mode"
$developerModeEnabled = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -ErrorAction SilentlyContinue
if ($null -eq $developerModeEnabled) {
    Write-Output "$(Get-Timestamp): Developer Mode is not enabled. This may cause issues."
}
# Try to get the .NET version, handle the case where dotnet is not installed
try {
    $dotnetVersion = & dotnet --version
    Write-Host "Installed .NET version: $dotnetVersion"

    # Conditional execution based on the --headless argument
    if ($headless -eq "--headless") {
        & dotnet "SeleniumDocker.dll" --headless
    } else {
        & dotnet "SeleniumDocker.dll"
    }
} catch {
    Write-Host "dotNET is not installed on this machine."

    # Optionally, you can exit the script if .NET is not installed
    exit
}
