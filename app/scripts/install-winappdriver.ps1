# install-winappdriver.ps1

# Function to install Chocolatey if not already installed
function Install-Chocolatey {
    if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Output "Installing Chocolatey"
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        choco feature enable -n=allowGlobalConfirmation
    } else {
        Write-Output "Chocolatey is already installed"
    }
}

# Enable developer mode
Write-Output "Enabling developer mode in Windows container"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1

# Install Chocolatey if needed
Install-Chocolatey

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
        Write-Output "Starting WinAppDriver"
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

# Additional logging for troubleshooting
Write-Output "Checking WinAppDriver process"
$winAppDriverProcess = Get-Process -Name WinAppDriver -ErrorAction SilentlyContinue
if ($null -ne $winAppDriverProcess) {
    Write-Output "WinAppDriver process is running"
} else {
    Write-Error "WinAppDriver process is not running"
    throw "WinAppDriver process failed to start"
}
