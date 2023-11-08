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
