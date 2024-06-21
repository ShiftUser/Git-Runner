# install-shift.ps1

Write-Output "Looking for Shift installer in the app/downloads directory..."
$shiftInstaller = Get-ChildItem -Path "app/downloads" -Filter "Shift*.exe" | Select-Object -First 1
if ($shiftInstaller) {
    Write-Output "Found Shift installer: $($shiftInstaller.FullName)"
    $process = Start-Process -FilePath $shiftInstaller.FullName -ArgumentList "/silent" -PassThru
    $process.WaitForExit()
    Write-Output "Shift installation completed."
} else {
    throw "Shift installer is not available."
}