# Function to get the current timestamp
function Get-Timestamp {
    return (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

try {
    # Define the path to the local Shift installer
    $installerPath = "C:\Users\Supattra Boonchalee\Downloads\Shift-*.exe"

    # Check if the installer file exists
    if (-not (Test-Path $installerPath)) {
        Write-Output "$(Get-Timestamp): Installer not found at $installerPath"
        exit 1
    }

    $arguments = "/i $installerPath /quiet /norestart"
    Write-Output "$(Get-Timestamp): Running installer: $installerPath with arguments: $arguments"
    
    # Start the installation process
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = "msiexec.exe"
    $processInfo.Arguments = $arguments
    $processInfo.RedirectStandardError = $true
    $processInfo.RedirectStandardOutput = $true
    $processInfo.UseShellExecute = $false
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo
    $process.Start() | Out-Null
    $process.WaitForExit()
    
    # Capture the output and errors
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()

    Write-Output "$(Get-Timestamp): Installer stdout: $stdout"
    Write-Output "$(Get-Timestamp): Installer stderr: $stderr"

    if ($process.ExitCode -ne 0) {
        Write-Output "$(Get-Timestamp): Installer exited with code $($process.ExitCode)"
        exit $process.ExitCode
    }

    Write-Output "$(Get-Timestamp): Completed installer: $installerPath"
} catch {
    Write-Output "$(Get-Timestamp): Error running installer: $installerPath"
    Write-Output $_.Exception.Message
}
