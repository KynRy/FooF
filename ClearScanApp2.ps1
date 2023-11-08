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
} else {
    Write-Host "Unable to determine the current user."
}

# Get the current logged-in user using WMI
$LoggedUser = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName

# Check if the username is in the DOMAIN\Username format
if ($LoggedUser -match '^(?<Domain>[\w\d]+)\\(?<Username>.+)$') {
    $Domain = $Matches['Domain']
    $Username = $Matches['Username']
} else {
    $Domain = $null
    $Username = $LoggedUser
}

# Define the path to the scanapp.exe
$ProgramPath = "C:\Program Files (x86)\ADOT_Scan\scanapp.exe"

# Check if the program file exists
if (Test-Path $ProgramPath -PathType Leaf) {
    # Start the program with the current user's credentials
    if ($Domain -eq $null) {
        # Local user
        Start-Process $ProgramPath
    } else {
        # Domain user
        Start-Process -Credential "$Domain\$Username" -FilePath $ProgramPath
    }
} else {
    Write-Host "The program file does not exist at $ProgramPath."
}

