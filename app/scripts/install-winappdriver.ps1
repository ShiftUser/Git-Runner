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

function Check-Port {
    param (
        [int]$port
    )
    $tcpConnections = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($tcpConnections) {
        Write-Output "Port $port is already in use."
        return $true
    } else {
        Write-Output "Port $port is available."
        return $false
    }
}

function Open-Port {
    param (
        [int]$port
    )
    Write-Output "Opening port $port in the Windows Firewall"
    New-NetFirewallRule -DisplayName "Allow Port $port" -Direction Inbound -LocalPort $port -Protocol TCP -Action Allow
}

function Install-WinAppDriver {
    Write-Output "Installing WinAppDriver using Chocolatey"
    $process = Start-Process -FilePath "choco" -ArgumentList "install winappdriver -y" -PassThru
    $process.WaitForExit()

    $winAppDriverPath = "C:\Program Files (x86)\Windows Application Driver\WinAppDriver.exe"
    if (Test-Path $winAppDriverPath) {
        Write-Output "WinAppDriver installation completed successfully."
        return $winAppDriverPath
    } else {
        Write-Error "Failed to install WinAppDriver."
        throw "Failed to install WinAppDriver."
    }
}

function Start-WinAppDriver {
    param (
        [string]$winAppDriverPath,
        [int]$port = 4724
    )

    if (Check-Port -port $port) {
        Write-Error "Port $port is in use. Trying another port."
        $port += 1
        Start-WinAppDriver -winAppDriverPath $winAppDriverPath -port $port
    } else {
        Open-Port -port $port
        try {
            Write-Output "Starting WinAppDriver on port $port"
            Start-Process -FilePath $winAppDriverPath -ArgumentList $port -NoNewWindow -Wait
            Start-Sleep -Seconds 5

            $winAppDriverProcess = Get-Process -Name WinAppDriver -ErrorAction SilentlyContinue
            if ($null -ne $winAppDriverProcess) {
                Write-Output "WinAppDriver process is running on port $port"
            } else {
                Write-Error "WinAppDriver process is not running"
                throw "WinAppDriver process failed to start on port $port"
            }
        } catch {
            Write-Error "Failed to start WinAppDriver."
            throw "Failed to start WinAppDriver."
        }
    }
}

Write-Output "Enabling developer mode in Windows container"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windo
