# Define a wildcard pattern for the process names
$processNamePattern = "scanapp*"

# Get processes with names matching the pattern
$runningProcesses = Get-Process | Where-Object { $_.ProcessName -like $processNamePattern }

if ($runningProcesses.Count -gt 0) {
    Write-Host "Terminating processes that match the pattern $processNamePattern..."
    $runningProcesses | ForEach-Object { $_.Kill() }
} else {
    Write-Host "No processes matching the pattern $processNamePattern are running."
}

# Get the username of the currently logged-on user using WMI
$currentUser = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName

if ($currentUser) {
    # Extract the username from the full format (DOMAIN\Username)
    $currentUser = $currentUser -replace '.*\\'

    # Construct the path to the user's AppData folder
    $folderToDelete = "C:\Users\$currentUser\AppData\Roaming\ScanApp2"

    if (Test-Path -Path $folderToDelete) {
        Remove-Item -Path $folderToDelete -Recurse -Force -Verbose
    } else {
        Write-Host "The folder $folderToDelete does not exist for the current user."
    }
} else {
    Write-Host "Unable to determine the current user."
}

# Check if "scanapp.exe" process is running
$processName = "scanapp.exe"
$runningProcess = Get-Process -Name $processName -ErrorAction SilentlyContinue

if ($runningProcess) {
    Write-Host "The $processName process is running."
} else {
    Write-Host "The $processName process is not running. Attempting again..."
    
    # Wait for 5 seconds (you can adjust this time as needed)
    Start-Sleep -Seconds 5
    
    $runningProcess = Get-Process -Name $processName -ErrorAction SilentlyContinue
    
    if ($runningProcess) {
        Write-Host "The $processName process is now running."
    } else {
        Write-Host "The $processName process is still not running after the second attempt."
    }
}




