# Stop the scanapp.exe process and any other windows
Get-Process -Name scanapp* | Stop-Process -Force

# Clear the contents of %appdata%\scan2
Write-Host "Clearing contents of %appdata%\ScanApp2..."
Remove-Item -Path "$env:C:\Users\Admin\AppData\Roaming\ScanApp2\*" -Recurse -Force

# Restart the scanapp.exe process
Write-Host "Restarting scanapp.exe..."
Start-Process -FilePath "C:\Program Files (x86)\ADOT_Scan\scanapp.exe"



