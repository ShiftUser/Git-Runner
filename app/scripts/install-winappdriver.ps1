# install-winappdriver.ps1

# Install WinAppDriver using Chocolatey
Write-Output "Installing WinAppDriver using Chocolatey"
$process = Start-Process -FilePath "choco" -ArgumentList "install winappdriver -y" -PassThru
$process.WaitForExit()

# Verify installation
$winAppDriverPath = "C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe"
if (Test-Path $winAppDriverPath) {
    Write-Output "WinAppDriver installation completed successfully."

    # Start WinAppDriver to verify it runs correctly
    try {
        Start-Process -FilePath $winAppDriverPath -ArgumentList "/silent" -NoNewWindow -Wait
        Write-Output "WinAppDriver started successfully."
    } catch {
        Write-Error "Failed to start WinAppDriver."
        throw "Failed to start WinAppDriver."
    }
} else {
    Write-Error "Failed to install WinAppDriver."
    throw "Failed to install WinAppDriver."
}


Write-Output "Enabling developer mode in Windows container"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1