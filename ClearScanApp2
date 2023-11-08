# Gracefully stop the scan.exe process
Get-Process -Name scanapp* | Stop-Process -Force

# Clear the contents of %appdata%\scan2
Write-Host "Clearing contents of %appdata%\ScanApp2..."
Remove-Item -Path "$env:APPDATA\ScanApp2\*" -Recurse -Force

# Restart the scan.exe process
Write-Host "Restarting scanapp.exe..."
Start-Process -FilePath "C:\Program Files (x86)\ADOT_Scan\scanapp.exe"



